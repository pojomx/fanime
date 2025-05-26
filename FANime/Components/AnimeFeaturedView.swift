//
//  AnimeFeaturedView.swift
//  FANime
//
//  Created by Alan Milke on 07/05/25.
//

import SwiftUI

struct AnimeFeaturedView: View {

    @AppStorage("useDefaultNames")
    var useDefaultNames: Bool = true
    
    var anime: Anime
    
    var body: some View {
        ZStack {
            Image("portada_ejemplo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: AnimeDetailView(anime: anime)) {
                        Text(useDefaultNames ? anime.titulo : (anime.titulo_default ?? anime.titulo))
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
                .background(Color.black.opacity(0.6))
                HStack {
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .foregroundColor(.red)
                        
                    }
                    
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .foregroundColor(.yellow)
                        
                    }
                    Spacer()
                }
                .background(Color.black.opacity(0.6))
            }
            
        }
    }
}

#Preview {
    AnimeFeaturedView(anime: Anime(data: JikanModel.getMockData()!))
}
