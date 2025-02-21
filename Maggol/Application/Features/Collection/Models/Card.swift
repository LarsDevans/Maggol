//
//  Card.swift
//  Maggol
//
//  Created by Lars Beijaard on 20/02/2025.
//

import Foundation

struct Card: Identifiable, Decodable {
    let id: String
    let name: String
    let imageURL: String
}
