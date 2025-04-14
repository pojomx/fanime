//
//  SettingsView.swift
//  FANime
//
//  Created by Alan Milke on 11/04/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            // MARK: - Section Header
            Section {
                HStack {
                    Spacer()
                    VStack (spacing: -6) {
                        Text("FANime")
                            .font(.system(size: 40, weight: .black))
                        Text("Follow your favorite anime")
                            .fontWeight(.medium)
                    }
                    Spacer()
                }
                .foregroundStyle(
                    LinearGradient(colors: [.pink, .purple], startPoint: .top, endPoint: .bottom)
                )
                .padding(.top, 8)
                
                VStack (spacing: 8) {
                    Text("About the content")
                        .font(.title2)
                        .fontWeight(.heavy)
                    Text("This app is getting all the data from Jikan API")
                        .font(.footnote)
                        .bold()
                    Text("Jikan (時間) is an unofficial & open-source API for the “most active online anime + manga community and database” — MyAnimeList.")
                        .font(.footnote)
                        .italic()
               
                    CustomListRowView(
                        rowContent: "jikan.moe",
                        rowURL: "https://jikan.moe",
                        rowLabel: "Jikan API",
                        rowIcon: "link",
                        rowTintColor: .blue,
                        )
                    
                    Text("I hope you enjoy the anime!")
                        .fontWeight(.heavy)
                        .foregroundColor(.pink)
                }
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
                
            } //: Section header
            .listRowSeparator(.hidden)
            
            Section {
                Text("The application is in development, and its a learning material, added a Backup feature that will store the Anime ID and if it was \"deleted\" or \"favorited\" so it can be restored if the database crashes.")
                    .font(.footnote)
                HStack {
                    Spacer()
                    Button(action: {
                        backupData()
                    }) {
                        Text("Backup")
                    }
                    Spacer()
                    Button(action: {
                        restoreData()
                    }) {
                        Text("Restore")
                    }
                    Spacer()
                }
            } header: {
                Text("Backup & Restore")
            }
            
            // MARK: - Section About
            Section {
                VStack {
                    Text("This app was made as a way of learning multiple tools and techniques in SwiftUI, SwiftData, Combine and other modern technologies.")
                        .font(.footnote)
                        .italic()
                    Text("Also, to follow up the new season of Anime, so I could keep up with every new Show and decide if I want to start watching it or not, and keep watching the series if I like it.")
                        .font(.footnote)
                        .italic()
                        .padding(.top, 8)
                }
                CustomListRowView(
                    rowContent: "twitter.com/pojomx",
                    rowURL: "https://x.com/pojomx",
                    rowLabel: "Twitter/X",
                    rowIcon: "bird",
                    rowTintColor: .pink,
                    )
                
                CustomListRowView(
                    rowContent: "twitch.tv/pojomx",
                    rowURL: "https://twitch.tv/pojomx",
                    rowLabel: "Twitch",
                    rowIcon: "gamecontroller",
                    rowTintColor: .purple,
                    )
                
                
            } header: {
                Text("About the application")
            } footer: {
                HStack{
                    Spacer()
                    Text("Version 1.0")
                    Spacer()
                }.padding(.vertical, 8)
            }
        }
    }
    
    func restoreData() {
        
    }
    
    func backupData() {
        
    }
}

#Preview {
    SettingsView()
}
