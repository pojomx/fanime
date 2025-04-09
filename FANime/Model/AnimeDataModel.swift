//
//  JikanDataModel.swift
//  FANime
//
//  Created by Alan Milke on 05/04/25.
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

@Model
final class Anime {
    
    //MARK: - Jikan Information
    var mal_id: Int //mal_id
    var mal_link: String?
    var portada: String?
    var portada_thumb: String?
    var titulo: String?
    var titulo_en: String?
    var type: String?
    var episodes: Int?
    var status: String?
    var airing: Bool
    var aired: JikanAired?
    var duration: String?
    var synopsis: String?
    var background: String?
    var season: String?
    var year: Int?
    var genres: [AnimeGenre]
    var broadcast: JikanBroadcast?
    var broadcastDay: Anime.BroadcastDays {
        if let broadcast = broadcast {
            return broadcast.getDayEnum()
        } else {
            return .na
        }
    }
    
    //MARK: - Own Information
    var favorite: Bool = false
    var favorite_date: Date? = nil
    var delete: Bool = false
    var delete_date: Date? = nil
    
    //MARK: - Methods
    init(data: JikanData)
    {
        mal_id = data.mal_id
        mal_link = data.url
        portada = data.images?.jpg.large_image_url
        portada_thumb = data.images?.jpg.small_image_url
        titulo = data.title
        titulo_en = data.title_english
        type = data.type
        episodes = data.episodes
        status = data.status
        airing = data.airing
        aired = data.aired
        duration = data.duration
        synopsis = data.synopsis
        background = data.background
        season = data.season
        year = data.year
        
        broadcast = data.broadcast
        genres = AnimeGenre.fromJikanCommon(data: data.genres)
    }
    
    func updateValues(data: Anime) {
        //mal_id = data.mal_id
        //mal_link = data.url
        portada = data.portada
        portada_thumb = data.portada_thumb
        titulo = data.titulo
        titulo_en = data.titulo_en
        type = data.type
        episodes = data.episodes
        status = data.status
        airing = data.airing
        aired = data.aired
        duration = data.duration
        synopsis = data.synopsis
        background = data.background
        season = data.season
        year = data.year
        
        broadcast = data.broadcast
        genres = data.genres
    }
    
    enum Tipos : String, CaseIterable {
        case tv = "TV"
        case ona = "ONA"
        case movie = "Movie"
        case special = "Special"
        case ova = "OVA"
        case music = "Music"
        case short = "Short"
        case pv = "PV"
        
    }
    
    enum BroadcastDays: String, CaseIterable {
        case sunday = "Sunday"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case na = "N/A" //Other
    }
}
