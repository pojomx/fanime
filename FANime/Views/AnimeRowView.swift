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
                
                Text(anime.titulo_en ?? anime.titulo ?? "")
                    .font(.headline)
                    .fontWeight(.bold)
                
                if let titulo = anime.titulo {
                    Text(titulo)
                        .font(.footnote)
                }
                
                HStack {
                    if anime.favorite {
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(.yellow)
                    }
                    if anime.delete {
                        Image(systemName: "trash.circle")
                            .foregroundColor(.red)
                        
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
                    
                    Text("\(String(describing: anime.broadcast?.day ?? ""))")
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
    var anime = Anime(data: JikanModel.getMockData()!)
    anime.delete = true
    anime.titulo_en = "Anime Eliminado"

    var anime2 = Anime(data: JikanModel.getMockData()!)
    anime2.favorite = true
    anime2.titulo_en = "Anime Favorito"
    
    var anime3 = Anime(data: JikanModel.getMockData()!)
    anime3.titulo_en = "Anime Normal"
    
    var anime4 = Anime(data: JikanModel.getMockData()!)
    anime4.delete = true
    anime4.favorite = true
    anime4.titulo_en = "Anime Favorito Eliminado"

    return
    List {
        AnimeRowView(anime: anime3)
        AnimeRowView(anime: anime)
        AnimeRowView(anime: anime2)
        AnimeRowView(anime: anime4)
    }
}
