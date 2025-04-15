//
//  AnimeList.swift
//  FANime
//
//  Created by Alan Milke on 04/04/25.
//

import SwiftUI
import SwiftData
import Combine

struct AnimeListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    let year = 2025
    
    @State private var animes: [Anime] = []
    
    var grouped: [String: [Anime]] {
        Dictionary(grouping: animes) { $0.type ?? "N/A" }
    }
    
    //Info about current service...
    @State private var queryYear: Int = 2025
    @State private var querySeason: AnimeSeason = .spring
    
    //Info about display data
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var hasNextPage: Bool = false
    @State private var currentPage: Int = 1
    
    //Other Combine Stuff
    @State private var observers: Set<AnyCancellable> = []
    
    var body: some View {
        let tipos = Anime.Tipos.allCases.map(\.rawValue)
        NavigationStack {
            HStack {
                Button {
                    (queryYear, querySeason) = Anime.getPreviousSeason(year: queryYear, season: querySeason)
                } label: {
                    Text(" < prev")
                }
                Spacer()
                VStack {
                    Text(String(queryYear))
                        .font(.caption)
                    HStack {
                        Text("winter")
                            .font(.caption2)
                            .foregroundStyle(querySeason == .winter ? .primary : .secondary)
                        Text("spring")
                            .font(.caption2)
                            .foregroundStyle(querySeason == .spring ? .primary : .secondary)
                        Text("summer")
                            .font(.caption2)
                            .foregroundStyle(querySeason == .summer ? .primary : .secondary)
                        Text("fall")
                            .font(.caption2)
                            .foregroundStyle(querySeason == .fall ? .primary : .secondary)
                        Text("others")
                            .font(.caption2)
                            .foregroundStyle(querySeason == .na ? .primary : .secondary)
                    }
                    
                }
                Spacer()
                Button {
                    (queryYear, querySeason) = Anime.getNextSeason(year: queryYear, season: querySeason)
                } label: {
                    Text("next >")
                }
            }
            List {
                ForEach(tipos, id: \.self) { type in
                    
                    let countedAnime = grouped[type]?.count ?? 0
                    if countedAnime > 0 {
                        Section(header: Text(type), footer: HStack {
                            Spacer()
                            Text("\(countedAnime) \(countedAnime == 1 ? "anime" : "animes")")
                                .font(.footnote)
                        }) {
                            ForEach(grouped[type] ?? []) { anime in
                                NavigationLink (destination: AnimeDetailView(anime: anime)) {
                                    AnimeRowView(anime: anime)
                                        .swipeActions(edge: .trailing) {
                                            Button {
                                                anime.delete.toggle()
                                                anime.delete_date = Date()
                                            } label: {
                                                Label("Eliminar", systemImage: "trash")
                                            }
                                        }
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                anime.favorite.toggle()
                                                anime.favorite_date = Date()
                                            } label: {
                                                if anime.favorite {
                                                    Label("Quitar de favoritos", systemImage: "star")
                                                        .tint(.secondary)
                                                } else {
                                                    Label("Agregar a favoritos", systemImage: "star.fill")
                                                        .tint(.yellow)
                                                }
                                            }
                                        }
                                } //.NAVLINK
                                .listRowBackground(
                                    anime.delete ? Color.red.opacity(0.2) :
                                        anime.favorite ? Color.yellow.opacity(0.2) : Color.clear)
                                
                            } //.FOREACH anime agrupado por tipo
                        } //.SECTION
                    } //.IF counted anime
                } //.FOREACH-Tipos
            } //.LIST
            .overlay {
                if isLoading {
                    CustomContentUnavailableView(
                        icon: "icloud.and.arrow.down",
                        title: "Downloading",
                        description: "The application is downloading content...")
                } else {
                    if animes.isEmpty {
                        CustomContentUnavailableView(
                            icon: "play.slash",
                            title: "No Anime",
                            description: "There is no anime to show.")
                    }
                }
            } //.LIST Overlay
            .toolbar {
                ToolbarItem {
                    if self.isLoading {
                        ProgressView()
                    } else {
                        Button(action: fetchDataSeason){
                            Label("Add Item", systemImage: "arrow.clockwise")
                                
                        }
                        .disabled(querySeason == .na)
                    }
                }
            }
        } //.NAVSTACK
        .navigationTitle("Spring 2025") // Posiblemente sobre la lista
        .onAppear() {
            let date = Date()
            self.queryYear = date.getYear() 
            self.querySeason = Anime.calculateSeason(month: date.getMonth())
            updateData()
        }
        .onChange(of: querySeason, { oldValue, newValue in
            updateData()
        })
        
    } //:BODY
    
    private func doNothing() {
        
    }
    
    private func updateData() {
        if querySeason == .na {
            updateData2()
        } else {
            updateData1()
        }
    }
    
    private func updateData1() {
        let season = "\(querySeason.rawValue)" // 2025spring - 2025na - 0na
        
        let descriptor = FetchDescriptor<Anime>(
            predicate: #Predicate { anime in anime.cSeason == season && anime.cYear == queryYear },
            sortBy: [SortDescriptor(\.titulo)])
        do {
            animes = try modelContext.fetch(descriptor)
        } catch {
            print("error: \(error)")
        }
    }
    
    private func updateData2() {
       
        
        let descriptor = FetchDescriptor<Anime>(
            predicate: #Predicate { anime in anime.cYear == queryYear }, // 2025...
            sortBy: [SortDescriptor(\.titulo)])
        do {
            animes = try modelContext.fetch(descriptor)
        } catch {
            print("error: \(error)")
        }
    }
    
    /*
    private func fetchData() {
        self.isLoading = true
        JikanService.shared.getSeasonNow(page: self.currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                            break
                        case .finished:
                            print("Finished fetching data")
                        }
                },
                receiveValue: { jikanModel in
                    jikanModel.data.forEach { animeData in
                        addAnime(anime: Anime(data:animeData), context: modelContext)
                    }
                    
                    if (jikanModel.pagination?.has_next_page ?? false) {
                        self.hasNextPage = true
                        self.currentPage += 1
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            //Get next Part in 2 seconds...
                            self.fetchData()
                        }
                    } else {
                        self.isLoading = false
                        self.currentPage = 1
                        self.hasNextPage = false
                        updateData()
                    }
                    
                })
            .store(in: &observers)
        
    }*/
    
    private func fetchDataSeason() {
        self.isLoading = true
        JikanService.shared.getSeason(year: queryYear, season: querySeason, page: self.currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                            break
                        case .finished:
                            print("Finished fetching data")
                        }
                },
                receiveValue: { jikanModel in
                    jikanModel.data.forEach { animeData in
                        let anime = Anime(data:animeData)
                        
                        anime.cYear = queryYear
                        anime.cSeason = querySeason.rawValue
                        
                        addAnime(anime: anime, context: modelContext)
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
                        updateData()
                    }
                    
                })
            .store(in: &observers)
    }
    
    func addAnime(anime: Anime, context: ModelContext) {
        // Buscar si ya existe un anime con ese título
        
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

    
    static func makeContainerPreview(container: ModelContainer) -> some View {
        let context = ModelContext(container)
        
        Anime.getMockData(count: 20).forEach { item in
            context.insert(item)
        }

        return AnimeListView()
            .modelContext(context)
    }
    
}

#Preview("Empty List") {
    AnimeListView()
        .modelContainer(for: Anime.self, inMemory: true)
}

#Preview("Some Data List") {
    let container = try! ModelContainer(for: Anime.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    return AnimeListView.makeContainerPreview(container: container)
}


