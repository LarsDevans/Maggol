//
//  Card.swift
//  Maggol
//
//  Created by Lars Beijaard on 20/02/2025.
//

import Foundation
import SwiftData

@Model
final class Card: Identifiable, Decodable, Equatable {
    var id: String
    var name: String
    var imageURL: CardImage
    var typeLine: String
    var manaCost: String
    var oracleText: String
    var setName: String
    var collectorNumber: String
    var rarity: String
    var power: String?
    var toughness: String?
    var foil: Bool
    var amount: Int
    
    private var keywords: [Keyword]
    
    var keywordStrings: [String] {
        get { keywords.map(\.value) }
        set { keywords = newValue.map(Keyword.init) }
    }
    
    var applicationCardId: String {
        "\(id)-\(foil ? "F" : "")"
    }
    
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
        case power
        case toughness
        case keywords
    }
    
    init(
        id: String,
        name: String,
        imageURL: CardImage,
        typeLine: String,
        manaCost: String,
        oracleText: String,
        setName: String,
        collectorNumber: String,
        rarity: String,
        power: String? = nil,
        toughness: String? = nil,
        keywords: [String],
        foil: Bool = false,
        amount: Int = 1
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.typeLine = typeLine
        self.manaCost = manaCost
        self.oracleText = oracleText
        self.setName = setName
        self.collectorNumber = collectorNumber
        self.rarity = rarity
        self.power = power
        self.toughness = toughness
        self.keywords = keywords.map(Keyword.init)
        self.foil = foil
        self.amount = amount
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
        power = try container.decode(String.self, forKey: .power)
        toughness = try container.decode(String.self, forKey: .toughness)
        
        let keywordStrings = try container.decode([String].self, forKey: .keywords)
        self.keywords = keywordStrings.map(Keyword.init)
        
        self.foil = false
        self.amount = 1
    }
    
    private struct Keyword: Codable {
        let value: String
        
        init(_ value: String) {
            self.value = value
        }
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        lhs.applicationCardId == rhs.applicationCardId
    }
}
