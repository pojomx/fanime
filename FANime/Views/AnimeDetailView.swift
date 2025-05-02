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
                    
                    CustomListRowView(rowContent: "Open in MAL",
                                      rowLabel: "",
                                      rowIcon: "square.and.arrow.up",
                                      rowTintColor: .orange)
                }
                
                Section(header: Text("Information")) {
                    CustomListRowView(rowContent: "\(anime.type ?? "")",
                                      rowLabel: "Type",
                                      rowIcon: "circle",
                                      rowTintColor: .blue)
                    
                    LabeledContent {
                        HStack {
                            Text("1")
                                .tint(.primary)
                                .fontWeight(.medium)
                            Text("/ \(anime.episodes ?? 0)")
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
                                Image(systemName: "movie")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                            Text("Episodes")
                        }
                        
                    }
                    
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
                    
                    
                }
                
                let a = getBroadcastDetails()
                
                Section(header: Text("Broadcast")) {
                    CustomListRowView(rowContent: "\(anime.status ?? "")",
                                      rowLabel: "Status",
                                      rowIcon: "calendar",
                                      rowTintColor: .blue)
                    
                    
                    if a.showCalendar {
                        CustomListRowView(rowContent: "\(anime.broadcast?.day ?? "No information")",
                                          rowContent2: "\(anime.broadcast?.string ?? "")",
                                          rowLabel: "Asia/Tokyo",
                                          rowIcon: "calendar",
                                          rowTintColor: .blue)
                    }
                    
                    if a.showClock {
                        CustomListRowView(rowContent: "\(Anime.calculateBroadcastDate(aired: anime.aired, broadcast: anime.broadcast) ?? "")",
                                          rowContent2: "\(TimeZone.current.identifier) (\(TimeZone.current.abbreviation()!))",
                                          rowLabel: "Local",
                                          rowIcon: "clock",
                                          rowTintColor: .blue)
                    }
                }
                
                Section(header: Text("Synopsis")) {
                    Text(anime.synopsis ?? "No synopsis")
                        .font(.callout)
                        .padding(.vertical)
                }
                
            }
        }
    }
        
    func getBroadcastDetails() -> (showCalendar: Bool, showClock: Bool) {
        let showCalendar: Bool
        let showClock: Bool
        switch anime.status {
            case "Finished Airing":
            showCalendar = false
            showClock = false
        case "Airing":
            showCalendar = true
            showClock = true
        case "Not yet aired":
            showCalendar = false
            showClock = false
        default:
            showCalendar = true
            showClock = true
        }
        
        return (showCalendar, showClock)
    }
    
}

#Preview {
    AnimeDetailView(anime: Anime(data: JikanModel.getMockData()!))
}

