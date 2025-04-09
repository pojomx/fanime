//
//  JikanModel.swift
//  FANime
//
//  Created by Alan Milke on 04/04/25.
//

import Foundation
import SwiftData

struct JikanModel: Decodable, Encodable {
    let data: [JikanData]
    let pagination: JikanPagination?
    
    static func getMockData() -> JikanData? {
        
        let JSONStringData = """
            {
                "pagination": 
                {
                    "last_visible_page": 6,
                    "has_next_page": true,
                    "current_page": 1,
                    "items": {
                        "count": 25,
                        "total": 130,
                        "per_page": 25
                    }
                },
                "data": [
                {
                    "mal_id": 51818,
                    "url": "https://myanimelist.net/anime/51818/Enen_no_Shouboutai__San_no_Shou",
                    "images": {
                        "jpg": {
                            "image_url": "https://cdn.myanimelist.net/images/anime/1527/146836.jpg",
                            "small_image_url": "https://cdn.myanimelist.net/images/anime/1527/146836t.jpg",
                            "large_image_url": "https://cdn.myanimelist.net/images/anime/1527/146836l.jpg"
                        },
                        "webp": {
                            "image_url": "https://cdn.myanimelist.net/images/anime/1527/146836.webp",
                            "small_image_url": "https://cdn.myanimelist.net/images/anime/1527/146836t.webp",
                            "large_image_url": "https://cdn.myanimelist.net/images/anime/1527/146836l.webp"
                        }
                    },
                    "trailer": {
                        "youtube_id": "nz-VCl7yUAw",
                        "url": "https://www.youtube.com/watch?v=nz-VCl7yUAw",
                        "embed_url": "https://www.youtube.com/embed/nz-VCl7yUAw?enablejsapi=1&wmode=opaque&autoplay=1",
                        "images": {
                            "image_url": "https://img.youtube.com/vi/nz-VCl7yUAw/default.jpg",
                            "small_image_url": "https://img.youtube.com/vi/nz-VCl7yUAw/sddefault.jpg",
                            "medium_image_url": "https://img.youtube.com/vi/nz-VCl7yUAw/mqdefault.jpg",
                            "large_image_url": "https://img.youtube.com/vi/nz-VCl7yUAw/hqdefault.jpg",
                            "maximum_image_url": "https://img.youtube.com/vi/nz-VCl7yUAw/maxresdefault.jpg"
                        }
                    },
                    "approved": true,
                    "titles": [
                        {
                            "type": "Default",
                            "title": "Enen no Shouboutai: San no Shou"
                        },
                        {
                            "type": "Synonym",
                            "title": "Enen no Shouboutai 3rd Season"
                        },
                        {
                            "type": "Japanese",
                            "title": "u708eu708eu30ceu6d88u9632u968a u53c2u30ceu7ae0"
                        },
                        {
                            "type": "English",
                            "title": "Fire Force Season 3"
                        }
                    ],
                    "title": "Enen no Shouboutai: San no Shou",
                    "title_english": "Fire Force Season 3",
                    "title_japanese": "u708eu708eu30ceu6d88u9632u968a u53c2u30ceu7ae0",
                    "title_synonyms": [
                        "Enen no Shouboutai 3rd Season"
                    ],
                    "type": "TV",
                    "source": "Manga",
                    "episodes": null,
                    "status": "Not yet aired",
                    "airing": false,
                    "aired": {
                        "from": "2025-04-05T00: 00: 00+00: 00",
                        "to": null,
                        "prop": {
                            "from": {
                                "day": 5,
                                "month": 4,
                                "year": 2025
                            },
                            "to": {
                                "day": null,
                                "month": null,
                                "year": null
                            }
                        },
                        "string": "Apr 5,2025 to ?"
                    },
                    "duration": "Unknown",
                    "rating": "PG-13 - Teens 13 or older",
                    "score": null,
                    "scored_by": null,
                    "rank": null,
                    "popularity": 1546,
                    "members": 164257,
                    "favorites": 1069,
                    "synopsis": "Third season of Enen no Shouboutai.",
                    "background": "",
                    "season": "spring",
                    "year": 2025,
                    "broadcast": {
                        "day": "Saturdays",
                        "time": "01: 53",
                        "timezone": "Asia/Tokyo",
                        "string": "Saturdays at 01: 53 (JST)"
                    },
                    "producers": [
                        {
                            "mal_id": 15,
                            "type": "anime",
                            "name": "Sony Pictures Entertainment",
                            "url": "https://myanimelist.net/anime/producer/15/Sony_Pictures_Entertainment"
                        },
                        {
                            "mal_id": 159,
                            "type": "anime",
                            "name": "Kodansha",
                            "url": "https://myanimelist.net/anime/producer/159/Kodansha"
                        },
                        {
                            "mal_id": 735,
                            "type": "anime",
                            "name": "Slow Curve",
                            "url": "https://myanimelist.net/anime/producer/735/Slow_Curve"
                        },
                        {
                            "mal_id": 1414,
                            "type": "anime",
                            "name": "bilibili",
                            "url": "https://myanimelist.net/anime/producer/1414/bilibili"
                        },
                        {
                            "mal_id": 1671,
                            "type": "anime",
                            "name": "DMM pictures",
                            "url": "https://myanimelist.net/anime/producer/1671/DMM_pictures"
                        },
                        {
                            "mal_id": 2139,
                            "type": "anime",
                            "name": "DMM Music",
                            "url": "https://myanimelist.net/anime/producer/2139/DMM_Music"
                        }
                    ],
                    "licensors": [],
                    "studios": [
                        {
                            "mal_id": 287,
                            "type": "anime",
                            "name": "David Production",
                            "url": "https://myanimelist.net/anime/producer/287/David_Production"
                        }
                    ],
                    "genres": [
                        {
                            "mal_id": 1,
                            "type": "anime",
                            "name": "Action",
                            "url": "https://myanimelist.net/anime/genre/1/Action"
                        },
                        {
                            "mal_id": 10,
                            "type": "anime",
                            "name": "Fantasy",
                            "url": "https://myanimelist.net/anime/genre/10/Fantasy"
                        },
                        {
                            "mal_id": 24,
                            "type": "anime",
                            "name": "Sci-Fi",
                            "url": "https://myanimelist.net/anime/genre/24/Sci-Fi"
                        }
                    ],
                    "explicit_genres": [],
                    "themes": [
                        {
                            "mal_id": 82,
                            "type": "anime",
                            "name": "Urban Fantasy",
                            "url": "https://myanimelist.net/anime/genre/82/Urban_Fantasy"
                        }
                    ],
                    "demographics": [
                        {
                            "mal_id": 27,
                            "type": "anime",
                            "name": "Shounen",
                            "url": "https://myanimelist.net/anime/genre/27/Shounen"
                        }
                    ]
                }
                ]
            }
            """
        
        let jsonData = Data(JSONStringData.utf8)
        do {
            let decoded = try JSONDecoder().decode(JikanModel.self, from: jsonData)
            return decoded.data.first
        } catch {
            print("Failed to decode JSON \(error)" )
        }
        return nil
    }
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

struct JikanData: Decodable, Encodable, Equatable {
    static func == (lhs: JikanData, rhs: JikanData) -> Bool {
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
    
    func getDayEnum() -> Anime.BroadcastDays? {
        if let day = day {
            return Anime.BroadcastDays(rawValue: day)
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
