//
//  SettingsHistoryViewModel.swift
//  FANime
//
//  Created by Alan Milke on 26/05/25.
//
import Foundation
import SwiftData
import Combine

class SettingsHistoryViewModel: ObservableObject {

    var modelContext : ModelContext?
    
    //Info about display data
    var errorMessage: String = ""
    @Published
    var isDownloading: Bool = false
    var isLoading: Bool = false
    var hasNextPage: Bool = false
    var currentPage: Int = 1
    
    var message: String = ""
    
    
    var seasonsToDownload: [JikanAPIModel] = []
    
    @Published
    var jikanList: [JikanAPIModel] = []
    
    //Other Combine Stuff
    var observers: Set<AnyCancellable> = []
    
    public init () {
        
    }
    
    func downloadAllData() {
        
        self.isDownloading = true
        for season in jikanList {
            if season.season != "na" {
                seasonsToDownload.append(season)
            }
        }
        
        if let season = seasonsToDownload.popLast() {
            fetchDataSeason(season: season.season, year: season.year)
        } else {
            self.isDownloading = false
        }
    }
    
    private func fetchDataSeason(season: String, year: Int) {
        guard let modelContext = self.modelContext else { return }
        
        self.isLoading = true
        
        let animeSeason = AnimeSeason(rawValue: season) ?? .na
        
        message = "App is downloading data from \(season) \(year)"
        
        JikanService.shared.getSeason(year: year, season: animeSeason, page: self.currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            break
                        case .finished:
                            let jikanApiModel = JikanAPIModel(
                                season: season,
                                year: year,
                                date: Date(),
                                response: 200)
                            
                            self.updateJikanApiData(apiData: jikanApiModel, context: modelContext)
                            
                            print("Finished fetching data")
                        }
                },
                receiveValue: { jikanModel in
                    jikanModel.data.forEach { animeData in
                        let anime = Anime(data:animeData)
                        
                        anime.cYear = year
                        anime.cSeason = season
                        anime.cDate = Date()
                        
                        self.addAnime(anime: anime, context: modelContext)
                    }
                    
                    if (jikanModel.pagination?.has_next_page ?? false) {
                        self.hasNextPage = true
                        self.currentPage += 1
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            //Get next Part in 2 seconds...
                            self.fetchDataSeason(season: season, year: year)
                        }
                    } else {
                        self.isLoading = false
                        self.currentPage = 1
                        self.hasNextPage = false
                        //PEEEEERO
                        if let season = self.seasonsToDownload.popLast() {
                            self.fetchDataSeason(season: season.season, year: season.year)
                        } else {
                            self.isDownloading = false
                        }
                    }
                    
                })
            .store(in: &observers)
    }
    
    func addAnime(anime: Anime, context: ModelContext) {
        // Buscar si ya existe un anime con ese id
        let mal_id = anime.mal_id
        
        let descriptor = FetchDescriptor<Anime>(predicate: #Predicate { $0.mal_id == mal_id })

        if let existing = try? context.fetch(descriptor), !existing.isEmpty {
            if let value = existing.first {
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
    
    func deleteItem(_ item: JikanAPIModel) {
        
        guard let modelContext = self.modelContext else { return }
        modelContext.delete(item)
        try? modelContext.save()
        
        updateData()
    }
    
    public func updateData() {
        guard let modelContext = self.modelContext else { return }
        
        let descriptor = FetchDescriptor<JikanAPIModel>()
    
        do {
            jikanList = try modelContext.fetch(descriptor)
        } catch {
            print("error: \(error)")
        }
    }
}
