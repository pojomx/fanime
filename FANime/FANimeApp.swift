//
//  FANimeApp.swift
//  FANime
//
//  Created by Alan Milke on 04/04/25.
//

import SwiftUI
import SwiftData

@main
struct FANimeApp: App {
    var body: some Scene {
        WindowGroup {
            AnimeMainView()
                .modelContainer(for: Anime.self)
        }
    }
}
