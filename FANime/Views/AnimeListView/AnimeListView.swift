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
        let tipos = Anime.Tipos.allCases.map(\.rawValue)
        NavigationStack {
            HStack {
                Button {
                    viewModel.btnPreviousSeason()
                } label: {
                    Text(" < prev")
                }
                Spacer()
                VStack {
                    Text(String(viewModel.queryYear))
                        .font(.caption)
                    HStack {
                        Text("winter")
                            .font(.caption2)
                            .foregroundStyle(viewModel.querySeason == .winter ? .primary : .secondary)
                        Text("spring")
                            .font(.caption2)
                            .foregroundStyle(viewModel.querySeason == .spring ? .primary : .secondary)
                        Text("summer")
                            .font(.caption2)
                            .foregroundStyle(viewModel.querySeason == .summer ? .primary : .secondary)
                        Text("fall")
                            .font(.caption2)
                            .foregroundStyle(viewModel.querySeason == .fall ? .primary : .secondary)
                        Text("others")
                            .font(.caption2)
                            .foregroundStyle(viewModel.querySeason == .na ? .primary : .secondary)
                    }
                }
                Spacer()
                Button {
                    viewModel.btnNextSeason()
                } label: {
                    Text("next >")
                }
            }
            List {
                ForEach(tipos, id: \.self) { type in
                    
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
                    if self.isLoading {
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


