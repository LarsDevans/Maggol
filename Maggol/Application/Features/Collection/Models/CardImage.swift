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
    
    enum CodingKeys: String, CodingKey {
        case normal = "normal"
    }
    
    init(normal: String) {
        self.normal = normal
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.normal = try container.decode(String.self, forKey: .normal)
    }
}
