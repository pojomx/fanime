//
//  AnimeListViewModel.swift
//  FANime
//
//  Created by Alan Milke on 04/06/25.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

class AnimeListViewModel : ObservableObject {
    
    var modelContext : ModelContext?
    
    @AppStorage("useDefaultNames") var useDefaultNames: Bool = true
    
    let year = 2025
    
    private var animes: [Anime] = []
    
    var grouped: [String: [Anime]] {
        Dictionary(grouping: animes) { $0.type ?? "N/A" }
    }
    
    public var errorMessage: String = "";
    
    //Info about current service...
    public var queryYear: Int = 2025
    public var querySeason: AnimeSeason = .spring
    
    //Info about display data
    public var isLoading: Bool = false
    public var hasNextPage: Bool = false
    public var currentPage: Int = 1
    
    //Other Combine Stuff
    public var observers: Set<AnyCancellable> = []
    
    init() {
        let date = Date()
        self.queryYear = date.getYear()
        self.querySeason = Anime.calculateSeason(month: date.getMonth())
    }
    
    func addAnime(anime: Anime, context: ModelContext) {
        // Buscar si ya existe un anime con ese id
        let mal_id = anime.mal_id
        
        let descriptor = FetchDescriptor<Anime>(predicate: #Predicate { $0.mal_id == mal_id })

        if let existing = try? context.fetch(descriptor), !existing.isEmpty {
            if let value = existing.first {
                print("Ya existe un anime con ese mal_id, valores actualizados.")
                value.updateValues(data: anime)
            } else {
                print("Algo raro sucedió.")
            }
            return
        }
        // Si no existe, lo guardas
        context.insert(anime)
    }
    
    func updateJikanApiData(apiData: JikanAPIModel, context: ModelContext) {
        let id = apiData.id
        
        let descriptor = FetchDescriptor<JikanAPIModel>(predicate: #Predicate { $0.id == id })

        if let existing = try? context.fetch(descriptor), !existing.isEmpty {
            if let value = existing.first {
                value.updateValues(data: apiData)
            } else {
                print("Algo raro sucedió.")
            }
            return
        }
        // Si no existe, lo guardas
        context.insert(apiData)
    }

    
    static func makeContainerPreview(container: ModelContainer) -> some View {
        let context = ModelContext(container)
        
        Anime.getMockData(count: 20).forEach { item in
            context.insert(item)
        }

        return AnimeListView()
            .modelContext(context)
    }
    
    public func updateData() {
        if querySeason == .na {
            updateData2()
        } else {
            updateData1()
        }
    }
    
    public func updateData1() {
        
        guard let modelContext else { return }
       
        let queryYear = self.queryYear
        
        let season = "\(querySeason.rawValue)" // 2025spring - 2025na - 0na
        
        let sort: SortDescriptor<Anime>
        
        if useDefaultNames {
            sort = SortDescriptor(\.titulo)
        } else {
            sort = SortDescriptor(\.titulo_default)
        }
        
        let descriptor = FetchDescriptor<Anime>(
            predicate: #Predicate { anime in anime.cSeason == season && anime.cYear == queryYear },
            sortBy: [sort])
        do {
            animes = try modelContext.fetch(descriptor)
        } catch {
            print("error: \(error)")
        }
    }
    
    private func updateData2() {

        guard let modelContext else { return }
        let queryYear = self.queryYear
        
        let sort: SortDescriptor<Anime>
        
        if useDefaultNames {
            sort = SortDescriptor(\.titulo)
        } else {
            sort = SortDescriptor(\.titulo_default)
        }
        
        let descriptor = FetchDescriptor<Anime>(
            predicate: #Predicate { anime in anime.cYear == queryYear }, // 2025...
            sortBy: [sort])
        do {
            animes = try modelContext.fetch(descriptor)
        } catch {
            print("error: \(error)")
        }
    }
    
    public func btnPreviousSeason() {
        (queryYear, querySeason) = Anime.getPreviousSeason(year: queryYear, season: querySeason)
    }
    
    public func btnNextSeason() {
        (queryYear, querySeason) = Anime.getNextSeason(year: queryYear, season: querySeason)
    }
    
    private func fetchDataSeason() {
        
        guard let modelContext else { return }
        
        self.isLoading = true
        JikanService.shared.getSeason(year: queryYear, season: querySeason, page: self.currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            break
                        case .finished:
                            let jikanApiModel = JikanAPIModel(
                                season: self.querySeason.rawValue,
                                year: self.queryYear,
                                date: Date(),
                                response: 200)
                            
                            self.updateJikanApiData(apiData: jikanApiModel, context: modelContext)
                            
                            print("Finished fetching data")
                        }
                },
                receiveValue: { jikanModel in
                    jikanModel.data.forEach { animeData in
                        let anime = Anime(data:animeData)
                        
                        anime.cYear = self.queryYear
                        anime.cSeason = self.querySeason.rawValue
                        anime.cDate = Date()
                        
        
                        self.addAnime(anime: anime, context: modelContext)
                    }
                    
                    if (jikanModel.pagination?.has_next_page ?? false) {
                        self.hasNextPage = true
                        self.currentPage += 1
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            //Get next Part in 2 seconds...
                            self.fetchDataSeason()
                        }
                    } else {
                        self.isLoading = false
                        self.currentPage = 1
                        self.hasNextPage = false
                        self.updateData()
                    }
                    
                })
            .store(in: &observers)
    }
}
