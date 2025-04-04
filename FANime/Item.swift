//
//  Item.swift
//  FANime
//
//  Created by Alan Milke on 04/04/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
