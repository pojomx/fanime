//
//  JikanModel.swift
//  FANime
//
//  Created by Alan Milke on 04/04/25.
//

import Foundation
import SwiftData

struct JikanModel: Decodable, Encodable {
    let data: [JikanAnime]
    let pagination: JikanPagination?
}

struct JikanPagination: Decodable, Encodable {
    let last_visible_page: Int
    let has_next_page: Bool
    let items: JikanPaginationItems
}

struct JikanPaginationItems: Decodable, Encodable {
    let count: Int
    let total: Int
    let per_page: Int
}

struct JikanAnime: Decodable, Encodable, Equatable {
    static func == (lhs: JikanAnime, rhs: JikanAnime) -> Bool {
        return lhs.mal_id == rhs.mal_id
    }
    
    let mal_id: Int //id, from MyAnimeList
    let url: String? //url for the Anime in MyAnimeList
    let images: JikanImages?
    let trailer: JikanTrailer?
    let approved: Bool?
    let titles: [JikanTitle]?
    let title: String?
    let title_english: String?
    let title_japanese: String?
    let title_synonyms: [String]?
    let type: String?
    let source: String?
    let episodes: Int?
    let status: String?
    let airing: Bool
    let aired: JikanAired?
    let duration: String?
    let rating: String?
    let score: Double?
    let scored_by: Int?
    let rank: Int?
    let popularity: Int?
    let members: Int?
    let favorites: Int?
    let synopsis: String?
    let background: String?
    let season: String?
    let year: Int?
    let broadcast: JikanBroadcast?
    let producers: [JikanCommon]?
    let licensors: [JikanCommon]?
    let studios: [JikanCommon]?
    let genres: [JikanCommon]?
    let explicit_genres: [JikanCommon]?
    let themes: [JikanCommon]?
    let demographics: [JikanCommon]?
    let relations: [JikanRelations]?
    let theme: [JikanCommon]?
    let external: [JikanCommon]?
    let streaming: [JikanCommon]?
}

struct JikanImages: Decodable, Encodable  {
    let jpg: JikanImage
    let webp: JikanImage
}

struct JikanTrailer: Decodable, Encodable  {
    let youtube_id: String?
    let url: String?
    let embed_url: String?
    let images: JikanImage?
}

struct JikanImage: Decodable, Encodable  {
    let image_url: String?
    let small_image_url: String?
    let large_image_url: String?
    let medium_image_url: String?
    let maximum_image_url: String?
}

struct JikanTitle: Decodable, Encodable  {
    let type: String
    let title: String
}

struct JikanCommon: Decodable, Encodable  {
    let mal_id: Int
    let type: String
    let name: String
    let url: String
}

struct JikanRelations: Decodable, Encodable  {
    let relation: String
    let entry: [JikanCommon]
}

struct JikanAired: Decodable, Encodable  {
    let from: String?
    let to: String?
    let prop: JikanProp?
}

struct JikanProp: Decodable, Encodable  {
    let from: JikanPropValue?
    let to: JikanPropValue?
}

struct JikanPropValue: Decodable, Encodable  {
    let day: Int?
    let month: Int?
    let year: Int?
}

struct JikanBroadcast: Decodable, Encodable  {
    let day: String?
    let time: String?
    let timezone: String?
    let string: String?
    
    func getDayEnum() -> Anime.BroadcastDays {
        if let day = day {
            return Anime.BroadcastDays(rawValue: day) ?? .na
        } else {
            return Anime.BroadcastDays.na
        }
    }
}

enum JikanServiceError: Error {
    case invalidUrl
    case invalidResponse
    case decodingError(Error)
    case noData
    case urlSessionError(Error)
    case unexpected(Error)
}
