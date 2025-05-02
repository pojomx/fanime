//
//  JikanServiceData.swift
//  FANime
//
//  Created by Alan Milke on 02/05/25.
//

import Foundation
import SwiftData

@Model
final class JikanAPIModel: Encodable, Decodable {
    
    var id: String //2025spring
    var season: String //Spring
    var year: Int //2025
    var date: Date // 20250502T10:51
    var response: Int //200 ok
    
    init (season: String, year: Int, date: Date, response: Int) {
        self.id = "\(String(year))\(season)" // 2025spring
        self.season = season
        self.year = year
        self.date = Date()
        self.response = response
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        season = try container.decode(String.self, forKey: .season)
        year = try container.decode(Int.self, forKey: .year)
        date = try container.decode(Date.self, forKey: .date)
        response = try container.decode(Int.self, forKey: .response)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(season, forKey: .season)
        try container.encode(year, forKey: .year)
        try container.encode(date, forKey: .date)
        try container.encode(response, forKey: .response)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case season
        case year
        case date
        case response
    }
    
    func updateValues(data: JikanAPIModel) {
        //mal_id = data.mal_id
        //mal_link = data.url
        date = data.date
    }
    
}
