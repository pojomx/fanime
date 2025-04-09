//
//  AnimeDetailView.swift
//  FANime
//
//  Created by Alan Milke on 04/04/25.
//

import SwiftUI

struct AnimeDetailView: View {
    
    let anime: Anime
    
    var body: some View {
        VStack (alignment: .center) {
            List {
                Section {
                    VStack{
                        ZStack (alignment: .topTrailing) {
                            
                            Image(systemName: "square.and.arrow.up")
                            
                            HStack {
                                Spacer()
                                AsyncImage(url: URL(string: anime.portada ?? "")!) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200)
                                        
                                } placeholder: {
                                    ProgressView()
                                }
                                Spacer()
                            }
                        }
                        Text(anime.titulo ?? "No title")
                            .font(.title)
                        HStack {
                            ForEach(anime.genres) { genre in
                                Text(genre.name)
                                    .font(.footnote)
                                    
                                    .padding(2)
                                    .padding(.horizontal, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.secondary)
                                            .shadow(radius: 5)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(10)
                    }
                }
                
                Section(header: Text("Information")) {
                    
                }
                
                Section(header: Text("Sinopsis")) {
                    Text(anime.synopsis ?? "No synopsis")
                        .font(.callout)
                        .padding(.vertical)
                }
                
            }
        
            Link("Ver en MAL", destination: URL(string: anime.mal_link ?? "")!)
            Spacer()
        }
    }
}

#Preview {
    AnimeDetailView(anime: Anime(data: JikanModel.getMockData()!))
}

