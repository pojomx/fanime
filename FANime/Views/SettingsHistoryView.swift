//
//  SettingsHistoryView.swift
//  FANime
//
//  Created by Alan Milke on 02/05/25.
//

import SwiftUI
import SwiftData
import Combine

struct SettingsHistoryView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var jikanApiModelList: [JikanAPIModel]
    
    //Info about display data
    @State private var errorMessage: String = ""
    @State private var isDownloading: Bool = false
    @State private var isLoading: Bool = false
    @State private var hasNextPage: Bool = false
    @State private var currentPage: Int = 1
    
    @State private var message: String = ""
    
    
    @State private var seasonsToDownload: [JikanAPIModel] = []
    
    //Other Combine Stuff
    @State private var observers: Set<AnyCancellable> = []
    
    var body: some View {
        VStack {
            if isLoading {
                CustomContentUnavailableView(
                    icon: "icloud.and.arrow.down",
                    title: "Downloading",
                    description: "\(message)")
            } else {
                List(jikanApiModelList) { item in
                    HStack {
                        Text(item.id)
                        Spacer()
                        Text("\(item.date)")
                            .font(.caption2)
                    }                    
                    .swipeActions(edge: .trailing) {
                        Button {
                            withAnimation{
                                modelContext.delete(item)
                                try? modelContext.save()
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .tint(.secondary)
                        }
                    }
                }
                Button {
                    downloadAllData()
                } label: {
                    Text("Regenerar base de datos...")
                }
                .disabled(isDownloading)
            }
        }
    }
    
    
    func downloadAllData() {
        for season in jikanApiModelList {
            if season.season != "na" {
                seasonsToDownload.append(season)
            }
        }
        self.isDownloading = true
        if let season = seasonsToDownload.popLast() {
            fetchDataSeason(season: season.season, year: season.year)
        } else {
            self.isDownloading = false
        }
    }
    
    private func fetchDataSeason(season: String, year: Int) {
        self.isLoading = true
        
        let animeSeason = AnimeSeason(rawValue: season) ?? .na
        
        message = "App is downloading data from \(season) \(year)"
        
        JikanService.shared.getSeason(year: year, season: animeSeason, page: self.currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                            break
                        case .finished:
                            let jikanApiModel = JikanAPIModel(
                                season: season,
                                year: year,
                                date: Date(),
                                response: 200)
                            
                             updateJikanApiData(apiData: jikanApiModel, context: modelContext)
                            
                            print("Finished fetching data")
                        }
                },
                receiveValue: { jikanModel in
                    jikanModel.data.forEach { animeData in
                        let anime = Anime(data:animeData)
                        
                        anime.cYear = year
                        anime.cSeason = season
                        anime.cDate = Date()
                        
                        addAnime(anime: anime, context: modelContext)
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
                        if let season = seasonsToDownload.popLast() {
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
}

#Preview {
    SettingsHistoryView()
}
