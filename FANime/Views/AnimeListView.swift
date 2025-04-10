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
    
    @Query(sort: [
        SortDescriptor(\Anime.titulo)                   // Luego por título ascendente
    ]) private var animes: [Anime] = []
    
    var grouped: [String: [Anime]] {
        Dictionary(grouping: animes) { $0.type ?? "N/A" }
    }
    
    @State private var errorMessage: String = ""
    
    @State private var isLoading: Bool = false
    @State private var hasNextPage: Bool = false
    @State private var currentPage: Int = 1
    
    @State private var observers: Set<AnyCancellable> = []
    
    var body: some View {
        let tipos = Anime.Tipos.allCases.map(\.rawValue)
        NavigationView {
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
                                }
                                .listRowBackground(
                                    anime.delete ? Color.red.opacity(0.2) :
                                        anime.favorite ? Color.yellow.opacity(0.2) : Color.clear)
                            }
                        }
                    }
                }
            }
            .overlay {
                if isLoading {
                    ZStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 500, height: 1000)
                        ContentUnavailableView("Content is loading", systemImage: "heart.circle", description: Text("We are downloading content..."))
                    }
                    
                } else {
                    if animes.isEmpty {
                        
                        ZStack {
                            ContentUnavailableView("No Anime", systemImage: "heart.circle", description: Text("No anime has been downloaded"))
                        }
                    }
                }
                
            }
            .navigationTitle("Temporada")
            .toolbar {
                ToolbarItem {
                    if self.isLoading {
                        ProgressView()
                    } else {
                        Button(action: fetchData) {
                            Label("Add Item", systemImage: "arrow.clockwise")
                        }
                    }
                }
            }
        }
        .onAppear() {
            print("onAppear")
        }
    
    }
    
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


