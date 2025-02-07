//
//  Item.swift
//  Maggol
//
//  Created by Lars Beijaard on 07/02/2025.
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
