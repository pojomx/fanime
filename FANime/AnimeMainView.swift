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
                    Text("Season")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                        .foregroundColor(.orange)
                    Text("Settings")
                }
        }
    }
}

#Preview("Some Data") {
    AnimeMainView()
        .modelContainer(Anime.preview)
}

