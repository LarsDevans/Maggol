//
//  Card.swift
//  Maggol
//
//  Created by Lars Beijaard on 20/02/2025.
//

import Foundation
import SwiftData

@Model
final class Card: Identifiable, Decodable {
    var id: String
    var name: String
    var imageURL: CardImage
    var typeLine: String
    var manaCost: String
    var oracleText: String
    var setName: String
    var collectorNumber: String
    var rarity: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_uris"
        case typeLine = "type_line"
        case manaCost = "mana_cost"
        case oracleText = "oracle_text"
        case setName = "set_name"
        case collectorNumber = "collector_number"
        case rarity
    }
    
    init(id: String, name: String, imageURL: CardImage, typeLine: String, manaCost: String, oracleText: String, setName: String, collectorNumber: String, rarity: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.typeLine = typeLine
        self.manaCost = manaCost
        self.oracleText = oracleText
        self.setName = setName
        self.collectorNumber = collectorNumber
        self.rarity = rarity
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageURL = try container.decode(CardImage.self, forKey: .imageURL)
        typeLine = try container.decode(String.self, forKey: .typeLine)
        manaCost = try container.decode(String.self, forKey: .manaCost)
        oracleText = try container.decode(String.self, forKey: .oracleText)
        setName = try container.decode(String.self, forKey: .setName)
        collectorNumber = try container.decode(String.self, forKey: .collectorNumber)
        rarity = try container.decode(String.self, forKey: .rarity)
    }
}
