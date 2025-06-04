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
    private var viewModel : AnimeListViewModel = AnimeListViewModel()
    
    var body: some View {
        NavigationStack {
            AnimeListSeasonNavigatorView(viewModel: viewModel)
            List {
                ForEach(Anime.getTiposStringArray(), id: \.self) { type in
                    let countedAnime = viewModel.grouped[type]?.count ?? 0
                    if countedAnime > 0 {
                        Section(header:
                                    HStack{
                                        Text(type).font(.title2)
                                    },
                                footer: HStack {
                            Spacer()
                            Text("\(countedAnime) \(countedAnime == 1 ? "anime" : "animes")")
                                .font(.footnote)
                        }) {
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
                if viewModel.isLoading {
                    CustomContentUnavailableView(
                        icon: "icloud.and.arrow.down",
                        title: "Downloading",
                        description: "The application is downloading content...")
                } else {
                    if viewModel.animes.isEmpty {
                        CustomContentUnavailableView(
                            icon: "play.slash",
                            title: "No Anime",
                            description: "There is no anime to show.")
                    }
                }
            } //.LIST Overlay
            .toolbar {
                ToolbarItem {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button(action: viewModel.fetchDataSeason){
                            Label("Add Item", systemImage: "arrow.clockwise")
                                
                        }
                        .disabled(viewModel.querySeason == .na)
                    }
                }
            }
        } //.NAVSTACK
        .navigationTitle("Spring 2025") // Posiblemente sobre la lista
        .onAppear() {
            viewModel.modelContext = modelContext
            viewModel.updateData()
        }
        .onChange(of: viewModel.querySeason, { oldValue, newValue in
            viewModel.updateData()
        })
    } //:BODY
    
    
}

#Preview("Empty List") {
    AnimeListView()
        .modelContainer(for: [Anime.self, JikanAPIModel.self], inMemory: true)
}

#Preview("Some Data List") {
    let container = try! ModelContainer(for: Anime.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    return AnimeListViewModel.makeContainerPreview(container: container)
}


