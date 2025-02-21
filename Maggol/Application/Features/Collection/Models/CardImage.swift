//
//  CardImage.swift
//  Maggol
//
//  Created by Lars Beijaard on 21/02/2025.
//

import Foundation

struct CardImage: Decodable {
    let normal: String
    
    enum CodingKeys: String, CodingKey {
        case normal = "normal"
    }
}
