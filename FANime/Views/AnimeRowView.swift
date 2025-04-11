//
//  AnimeRowView.swift
//  FANime
//
//  Created by Alan Milke on 04/04/25.
//

import SwiftUI

struct AnimeRowView: View {
    
    let anime: Anime

    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: anime.portada_thumb ?? "")!) { image in
                    image.frame(width: 42, height: 59)
                } placeholder: {
                    ZStack{
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 42, height: 59)
                        ProgressView()
                    }
                }
                .padding(.trailing, 8)
            }.frame(maxWidth: 54)
            VStack (alignment: .leading) {
                
                Text(anime.titulo)
                    .font(.headline)
                    .fontWeight(.bold)
               
                Text(anime.titulos.first(where: { $0.type == "Default" })?.title ?? "")
                        .font(.footnote)
                
                HStack {
                    if anime.favorite {
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(.yellow)
                    }
                    if anime.delete {
                        Image(systemName: "trash.circle")
                            .foregroundColor(.red)
                        
                    }
                    ForEach(anime.demographics, id: \.mal_id) { demo in
                        Text(demo.name)
                            .font(.caption2)
                    }
                    
                    ForEach(anime.genres) { genre in
                        Text(genre.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                }
                
                
                HStack {
                    
                    Text("[\(anime.type ?? "N/A")]")
                        .font(.custom("", size: 8))
                    
                    Text("\(String(describing: anime.broadcast_local?.day ?? ""))")
                        .font(.caption)
                
                    if let year = anime.year {
                        Text("\(anime.season ?? "") \(String(year))")
                            .font(.caption)
                    } else {
                        Text("\(anime.season ?? "")")
                    }
                    
                }
       
                
            }
        }
        .listRowBackground(
            anime.delete ? Color.red.opacity(0.1) :
                anime.favorite ? Color.yellow.opacity(0.1) : Color.clear)
    }
}

#Preview {
    let animeList = Anime.getMockData()
    
    List {
        ForEach(animeList, id: \.mal_id) { anime in
            AnimeRowView(anime: anime)
        }
    }
}
