//
//  CardImage.swift
//  Maggol
//
//  Created by Lars Beijaard on 21/02/2025.
//

import Foundation
import SwiftData

@Model
final class CardImage: Decodable {
    var normal: String
    var artCrop: String
    
    enum CodingKeys: String, CodingKey {
        case normal = "normal"
        case artCrop = "art_crop"
    }
    
    init(normal: String, artCrop: String) {
        self.normal = normal
        self.artCrop = artCrop
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.normal = try container.decode(String.self, forKey: .normal)
        self.artCrop = try container.decode(String.self, forKey: .artCrop)
    }
}
