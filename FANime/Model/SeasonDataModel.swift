//
//  SeasonDataModel.swift
//  FANime
//
//  Created by Alan Milke on 10/04/25.
//
import Foundation
import SwiftData

@Model
final class Season {
    
    //MARK: - Jikan Information
    var id: Int
    var seasons: [String]
    
    //MARK: - Own Information
    var favorite: Bool = false
    var favorite_date: Date? = nil
    var delete: Bool = false
    var delete_date: Date? = nil
    
    init(id: Int, seasons: [String], favorite: Bool, favorite_date: Date? = nil, delete: Bool, delete_date: Date? = nil) {
        self.id = id
        self.seasons = seasons
        self.favorite = favorite
        self.favorite_date = favorite_date
        self.delete = delete
        self.delete_date = delete_date
    }
    
    init(data: JikanSeason) {
        self.id = data.year
        self.seasons = data.seasons
    }
    
    init(_ data: Season) {
        self.id = data.id
        self.seasons = data.seasons
    }
}
