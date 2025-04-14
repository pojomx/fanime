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
                            
                            VStack {
                                Link(destination: URL(string: anime.mal_link ?? "")!) {
                                    Image(systemName: "square.and.arrow.up")
                                        .padding(.vertical)
                                }
                                
                                Link(destination: URL(string: anime.mal_link ?? "")!) {
                                    Image(systemName: "link")
                                        .padding(.vertical)
                                }
                            }
                            
                            HStack {
                                Spacer()
                                AsyncImage(url: URL(string: anime.portada ?? "")!) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200)
                                        .padding(.vertical)
                                        
                                } placeholder: {
                                    ProgressView()
                                }
                                Spacer()
                            }
                        }
                        Text(anime.titulo)
                            .font(.title)
                        
                        ForEach(anime.titulos, id: \.type) { titulo in
                            Text(titulo.title)
                                .font(.caption)
                        }
                        
                        HStack {
                            ForEach(anime.demographics, id:\.mal_id) { demographic in
                                Text(demographic.name)
                                    .font(.footnote)
                                    .padding(2)
                                    .padding(.horizontal, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.red)
                                            .shadow(radius: 5)
                                    )
                                    .foregroundColor(.white)
                            }
                            
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
                    CustomListRowView(rowContent: "\(anime.type ?? "")",
                                      rowLabel: "Type",
                                      rowIcon: "circle",
                                      rowTintColor: .blue)
                    
                    CustomListRowView(rowContent: "\(anime.rating == nil ? "" : anime.rating!)",
                                      rowLabel: "Rating",
                                      rowIcon: "circle",
                                      rowTintColor: .blue)
                    
                    
                    CustomListRowView(rowContent: "\(anime.season ?? "") \(anime.year == nil ? "" : String(anime.year!))",
                                      rowLabel: "Season",
                                      rowIcon: "circle",
                                      rowTintColor: .blue)
                    
                    CustomListRowView(rowContent: "\(anime.source ?? "")",
                                      rowLabel: "Source",
                                      rowIcon: "circle",
                                      rowTintColor: .blue)

                    CustomListRowView(rowContent: "\(anime.status ?? "")",
                                      rowLabel: "Status",
                                      rowIcon: "calendar",
                                      rowTintColor: .blue)
                }
                
                Section(header: Text("Broadcast")) {
                    CustomListRowView(rowContent: "\(anime.broadcast?.day ?? "No information")",
                                      rowContent2: "\(anime.broadcast?.string ?? "")",
                                      rowLabel: "Asia/Tokyo",
                                      rowIcon: "calendar",
                                      rowTintColor: .blue)
                    
                    CustomListRowView(rowContent: "\(Anime.calculateBroadcastDate(aired: anime.aired, broadcast: anime.broadcast) ?? "")",
                                      rowContent2: "\(TimeZone.current.identifier) (\(TimeZone.current.abbreviation()!))",
                                      rowLabel: "Local",
                                      rowIcon: "clock",
                                      rowTintColor: .blue)
                }
                
                Section(header: Text("Synopsis")) {
                    Text(anime.synopsis ?? "No synopsis")
                        .font(.callout)
                        .padding(.vertical)
                }
                
            }
        }
    }
}

#Preview {
    AnimeDetailView(anime: Anime(data: JikanModel.getMockData()!))
}

