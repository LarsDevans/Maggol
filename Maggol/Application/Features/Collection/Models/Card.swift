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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_uris"
        case typeLine = "type_line"
    }
    
    init(id: String, name: String, imageURL: CardImage, typeLine: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.typeLine = typeLine
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageURL = try container.decode(CardImage.self, forKey: .imageURL)
        typeLine = try container.decode(String.self, forKey: .typeLine)
    }
}
