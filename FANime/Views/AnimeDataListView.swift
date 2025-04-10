//
//  AnimeDataListView.swift
//  FANime
//
//  Created by Alan Milke on 07/04/25.
//

import SwiftUI
import SwiftData
import Combine

struct AnimeDataListView: View {
   
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Anime> { $0.favorite && !$0.delete },
           sort: [
                SortDescriptor(\Anime.type, order: .reverse),   // Primero ordena por tipo descendente
                SortDescriptor(\Anime.titulo)                   // Luego por título ascendente
           ]) private var animes: [Anime] = []
    
    var grouped: [String: [Anime]] {
        Dictionary(grouping: animes) { $0.type ?? "N/A" }
    }

    @State private var isAlertShowing: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(animes) { anime in
                    Text("\(anime.titulo)")
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                modelContext.delete(anime)
                            }
                        }
                }
            }
            .navigationTitle("Anime List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAlertShowing.toggle()

                    } label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                }
            }
            .overlay {
                if animes.isEmpty {
                    ContentUnavailableView("Anime List", systemImage: "heart.circle", description: Text("No animes yet."))
                }
            }
        }
    }
}

#Preview("Empty List") {
    AnimeDataListView()
        .modelContainer(for: Anime.self, inMemory: true)
}
