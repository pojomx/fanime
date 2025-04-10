//
//  AnimeMainView.swift
//  FANime
//
//  Created by Alan Milke on 08/04/25.
//

import SwiftUI
import SwiftData

struct AnimeMainView: View {
    var body: some View {
        TabView {
            AnimeFavoriteListView()
                .tabItem {
                    Image(systemName: "star")
                        .foregroundColor(.orange)
                    Text("Favorites")
                }
            AnimeListView()
                .tabItem {
                    Image(systemName: "list.clipboard")
                        .foregroundColor(.orange)
                    Text("Temporada")
                }
        }
    }
    
    
    static func makeContainerPreview(container: ModelContainer) -> some View {
        let context = ModelContext(container)
        
        Anime.getMockData(count: 20).forEach { item in
            context.insert(item)
        }

        return AnimeMainView()
            .modelContext(context)
    }
}

#Preview("Empy Model") {
    AnimeMainView()
    
}

#Preview("Some Data") {
    let container = try! ModelContainer(for: Anime.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    return AnimeMainView.makeContainerPreview(container: container)
}

