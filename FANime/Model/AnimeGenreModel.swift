//
//  AnimeGenreModel.swift
//  FANime
//
//  Created by Alan Milke on 11/04/25.
//

import Foundation
import SwiftData

@Model
final class AnimeGenre {
    var id: Int
    var type: String
    var name: String
    var url: String
    
    init (data: JikanCommon) {
        id = data.mal_id
        type = data.type
        name = data.name
        url = data.url
    }
    
    init(mal_id: Int, type: String, name: String, url: String) {
        self.id = mal_id
        self.type = type //Anime
        self.name = name //Action, SciFi, Fantasy
        self.url = url
    }
    
    static func fromJikanCommon(data: [JikanCommon]?) -> [AnimeGenre] {
        guard let data else { return [] }
        return data.map { AnimeGenre(data: $0) }
    }
}
