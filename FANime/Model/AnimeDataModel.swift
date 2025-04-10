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
    var titulo: String
    var titulos: [JikanTitle]
    var type: String?
    var source: String?
    var episodes: Int?
    var status: String?
    var airing: Bool
    var aired: JikanAired?
    var duration: String?
    var synopsis: String?
    var background: String?
    var season: String?
    var year: Int?
    var rating: String?
    var genres: [AnimeGenre]
    var demographics: [JikanCommon]
    var broadcast: JikanBroadcast?
    var broadcast_local: JikanBroadcast?
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
    init(data: JikanAnime)
    {
        mal_id = data.mal_id
        mal_link = data.url
        portada = data.images?.jpg.large_image_url
        portada_thumb = data.images?.jpg.small_image_url
        titulo = data.titles?.first(where: { $0.type == "English" })?.title ?? data.titles?.first(where: { $0.type == "Default" })?.title ?? "N/A"
        titulos = data.titles ?? []
        type = data.type
        source = data.source
        episodes = data.episodes
        status = data.status
        airing = data.airing
        aired = data.aired
        duration = data.duration
        synopsis = data.synopsis
        background = data.background
        season = data.season
        year = data.year
        rating = data.rating
        broadcast = data.broadcast
        broadcast_local = Anime.calculateBroadcastLocal(aired: data.aired, broadcast: data.broadcast)
        genres = AnimeGenre.fromJikanCommon(data: data.genres)
        demographics = data.demographics ?? []
    }
    
    func updateValues(data: Anime) {
        //mal_id = data.mal_id
        //mal_link = data.url
        portada = data.portada
        portada_thumb = data.portada_thumb
        titulo = data.titulo
        titulos = data.titulos
        type = data.type
        source = data.source
        episodes = data.episodes
        status = data.status
        airing = data.airing
        aired = data.aired
        duration = data.duration
        synopsis = data.synopsis
        background = data.background
        season = data.season
        year = data.year
        rating = data.rating
        broadcast = data.broadcast
        broadcast_local = data.broadcast_local
        genres = data.genres
        demographics = data.demographics
    }
    
    static func calculateBroadcastLocal(aired: JikanAired?, broadcast: JikanBroadcast?) -> JikanBroadcast? {
        guard let local = calculateBroadcastDate(aired: aired, broadcast: broadcast) else { return nil }
        let local_split = local.split(separator: ", ");
        
        let local_day = String(local_split[0])
        let local_time = String(local_split[1])
        
        let jikanLocal = JikanBroadcast(day: "\(local_day)s", time: local_time, timezone: TimeZone.current.identifier, string: "\(local_day)s at \(local_time) (\(TimeZone.current.abbreviation()!))")
        return jikanLocal
    }
    
    static func calculateBroadcastDate(aired: JikanAired?, broadcast: JikanBroadcast?) -> String? {
        let dateFormatString = "yyyy-MM-dd HH:mm"
        let finalFormatString = "EEEE, HH:mm"
        
        //Get DATE part of the episode...
        guard let aired = aired?.from else { return nil } //No Aired information
        
        //We have now the DATE on this format: 2025-04-05T00: 00: 00+00: 00
        let date_part = aired.split(separator: "T")[0]
        
        //Next, we need the TIME part
        let time_part = broadcast?.time ?? "00:00"

        //Next we add the TimeZone Part
        guard let timezone = TimeZone(identifier: broadcast?.timezone ?? "Asia/Tokyo" ) else { return nil }
                
        let dateString = "\(date_part) \(time_part)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatString
        formatter.timeZone = timezone

        guard let broadcastDate = formatter.date(from: dateString) else { return nil }
        
        formatter.dateFormat = finalFormatString
        formatter.timeZone = TimeZone.current

        return formatter.string(from: broadcastDate)
    }
    
    static func getMockData(count: Int = 4) -> [Anime] {
        
        let animeList = JikanModel.getMockListData().map { Anime(data: $0) }
        
            let anime1 = animeList[0]
            let anime2 = animeList[1]
            let anime3 = animeList[2]
            let anime4 = animeList[3]
            
            anime2.favorite = true
            anime2.favorite_date = Date()
            
            anime3.delete = true
            anime3.delete_date = Date()
            
            
            anime4.favorite = true
            anime4.favorite_date = Date()
            anime4.delete = true
            anime4.delete_date = Date()
        
        var lista = [anime1, anime2, anime3, anime4]
        
        if lista.count < count {
            let maxCount = animeList.count < count ? animeList.count : count
            for i in 4..<maxCount {
                let newAnime = animeList[i]
                
                newAnime.favorite = Bool.random()
                newAnime.delete = Bool.random()
                
                lista.append(newAnime)
            }
        }
        
        return lista
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
        case na = "N/A" //Other        case na = "N/A" //Other
    }
    
    enum BroadcastDays: String, CaseIterable {
        case monday = "Mondays"
        case tuesday = "Tuesdays"
        case wednesday = "Wednesdays"
        case thursday = "Thursdays"
        case friday = "Fridays"
        case saturday = "Saturdays"
        case sunday = "Sundays"
        case na = "N/A" //Other
    }
}
