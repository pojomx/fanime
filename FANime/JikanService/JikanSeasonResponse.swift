//
//  JikanSeasonResponse.swift
//  FANime
//
//  Created by Alan Milke on 10/04/25.
//

import Foundation

struct JikanSeasonResponse: Decodable, Encodable {
    let data: [JikanSeason]
    let pagination: JikanPagination?
}

struct JikanSeason: Decodable, Encodable {
    //https://api.jikan.moe/v4/seasons
    //{"year":1917,"seasons":["winter","spring","summer","fall"]}
    let year: Int
    let seasons: [String]
}
