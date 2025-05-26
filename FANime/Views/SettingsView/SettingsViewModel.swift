//
//  SettingsViewModel.swift
//  FANime
//
//  Created by Alan Milke on 26/05/25.
//

import Foundation
import SwiftData

class SettingsViewModel: ObservableObject {
    
    var useDefaultNames: Bool {
        didSet {
            UserDefaults.standard.set(useDefaultNames, forKey: "useDefaultNames")
        }
    }
    
    @Published var animes: [Anime] = Anime.getMockData()
    
    init() {
        self.useDefaultNames = UserDefaults.standard.bool(forKey: "useDefaultNames")
    }
    
}
