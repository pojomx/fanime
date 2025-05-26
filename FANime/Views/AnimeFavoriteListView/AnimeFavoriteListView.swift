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
    @ObservedObject var viewModel = AnimeFavoriteListViewModel()
    
    var body: some View {

        NavigationView {
            List {
                ForEach(viewModel.dias, id: \.self) { type in
                    let countedAnime = viewModel.grouped[type]?.count ?? 0
                    if countedAnime > 0 {
                        Section(header: Text(type)) {
                            ForEach(viewModel.grouped[type] ?? []) { anime in
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
                                                withAnimation {
                                                    anime.favorite.toggle()
                                                    anime.favorite_date = Date()
                                                }
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
                Section (header: Text("Comming soon")) {
                    ForEach(viewModel.animesProximos, id: \.id) { anime in
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
                                        withAnimation {
                                            anime.favorite.toggle()
                                            anime.favorite_date = Date()
                                        }
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
                
                Section (header: Text("Ended")) {
                    ForEach(viewModel.animesFinalizados, id: \.id) { anime in
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
                                        withAnimation {
                                            anime.favorite.toggle()
                                            anime.favorite_date = Date()
                                        }
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
            .overlay {
                if viewModel.animes.isEmpty && viewModel.animesFinalizados.isEmpty {
                    CustomContentUnavailableView(
                        icon: "star.slash.fill",
                        title: "No Anime",
                        description: "There is no anime marked as favorite.")
                }
            }
            .navigationTitle("Favoritos")
            .onAppear() {
                viewModel.modelContext = modelContext
                viewModel.updateData()
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
    
    return AnimeFavoriteListViewModel.makeContainerPreview(container: container)
}
