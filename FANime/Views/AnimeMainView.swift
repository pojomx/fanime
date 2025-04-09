//
//  AnimeMainView.swift
//  FANime
//
//  Created by Alan Milke on 08/04/25.
//

import SwiftUI

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
}

#Preview {
    AnimeMainView()
}
