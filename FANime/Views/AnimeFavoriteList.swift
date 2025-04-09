//
//  AnimeFavoriteListView.swift
//  FANime
//
//  Created by Alan Milke on 07/04/25.
//

import SwiftUI
import SwiftData
import Combine

struct AnimeFavoriteListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Anime> { $0.favorite && !$0.delete },
           sort: [
            SortDescriptor(\Anime.titulo)                   // Luego por título ascendente
           ]) private var animes: [Anime] = []
    
    var grouped: [String: [Anime]] {
        Dictionary(grouping: animes) { $0.broadcast?.day ?? "N/A" }
    }
    
    var body: some View {
        
        let dias = Anime.BroadcastDays.allCases.map(\.rawValue)
        
        NavigationView {
            List {
                ForEach(dias, id: \.self) { type in
                    
                    let countedAnime = grouped[type]?.count ?? 0
                    
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
                        }
                    }
                }
            }
            .overlay {
                if animes.isEmpty {
                    ZStack {
                        ContentUnavailableView("No Anime", systemImage: "star.circle", description: Text("No anime has been favorited yet."))
                            .tint(.yellow)
                    }
                }
            }
            .navigationTitle("Favoritos")
            .onAppear() {
                print("onAppear")
            }
        }
    }
}

#Preview("Empty List") {
    AnimeFavoriteListView()
        .modelContainer(for: Anime.self, inMemory: true)
}

#Preview("Some Data List") {
    let container = try! ModelContainer(for: Anime.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let anime = Anime(data: JikanModel.getMockData()!)
    anime.favorite = true
    container.mainContext.insert(anime)
    
    return AnimeFavoriteListView()
        .modelContainer(container)
}
