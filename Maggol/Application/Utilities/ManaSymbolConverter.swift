//
//  ManaSymbolConverter.swift
//  Maggol
//
//  Created by Linde on 05/03/2025.
//

import Foundation
import SwiftUI

enum ManaSymbol: String, CaseIterable {
    case B, G, C, R, T, U, W, 
         one = "1",
         two = "2",
         three = "3",
         four = "4",
         five = "5",
         six = "6",
         seven = "7",
         eight = "8",
         nine = "9",
         ten = "10"
    
    static private let imageMap: [ManaSymbol: Image] = [
        .one: Image(._1),
        .two: Image(._2),
        .three: Image(._3),
        .four: Image(._4),
        .five: Image(._5),
        .six: Image(._6),
        .seven: Image(._7),
        .eight: Image(._8),
        .nine: Image(._9),
        .ten: Image(._10),
        .B: Image(.B),
        .G: Image(.G),
        .C: Image(.C),
        .R: Image(.R),
        .T: Image(.T),
        .U: Image(.U),
        .W: Image(.W)
    ]
    
    var image: Image {
        return Self.imageMap[self]!
    }
    
    static func asImageSerie(manaCost: String) -> [Image?] {
        let pattern = /\{([A-Z0-9]+)\}/
        let images = manaCost.matches(of: pattern).compactMap { match -> Image? in
            guard let symbol = ManaSymbol(rawValue: String(match.1)) else { return nil }
            return symbol.image
        }
        return images
    }
}
