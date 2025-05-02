//
//  AnimeEpisodesRowView.swift
//  FANime
//
//  Created by Alan Milke on 20/04/25.
//

import SwiftUI

struct AnimeEpisodesRowView: View {
    
    let anime: Anime
    
    var body: some View {
        LabeledContent {
            HStack {
                Text("1")
                    .tint(.primary)
                    .fontWeight(.medium)
                    .padding(.trailing, -10)
                Text("/\(anime.episodes ?? 0)")
                    .tint(.pink)
                    .fontWeight(.light)
                    .font(.caption)
            }
            
        } label: {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                Text("Episodes")
            }
            
        }
    }
}

#Preview {
    let animeList = Anime.getMockData()
    
    List {
        ForEach(animeList, id: \.mal_id) { anime in
            AnimeEpisodesRowView(anime: anime)
        }
    }
}
