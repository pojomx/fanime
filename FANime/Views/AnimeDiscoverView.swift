//
//  AnimeDiscoverView.swift
//  FANime
//
//  Created by Alan Milke on 08/04/25.
//

import SwiftUI
import SwiftData

struct AnimeDiscoverView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(
        filter: #Predicate<Anime> { !$0.favorite && !$0.delete }
    ) private var animes: [Anime] = []
    
    var body: some View {
        TabView {
            ForEach(animes, id: \.id) { anime in
                AnimeFeaturedView(anime: anime)
            }
        }
        .tabViewStyle(.tabBarOnly)
    }
    
}

#Preview {
    
    AnimeDiscoverView()
        .modelContainer(Anime.preview)
}
