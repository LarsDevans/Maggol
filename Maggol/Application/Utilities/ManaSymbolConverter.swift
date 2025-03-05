//
//  ManaSymbolConverter.swift
//  Maggol
//
//  Created by Linde on 05/03/2025.
//

import Foundation
import SwiftUI

class ManaSymbolConverter {
    func convertManaCost(manaCost: String) -> [Image] {
        let pattern = /\{([A-Z0-9]+)\}/
        var images: [Image] = []
        for match in manaCost.matches(of: pattern) {
            let symbol = match.1
            switch String(symbol) {
            case "B":
                images.append(Image(.B))
            case "G":
                images.append(Image(.G))
            case "C":
                images.append(Image(.C))
            case "R":
                images.append(Image(.R))
            case "T":
                images.append(Image(.T))
            case "U":
                images.append(Image(.U))
            case "W":
                images.append(Image(.W))
            case "1":
                images.append(Image(._1))
            case "2":
                images.append(Image(._2))
            case "3":
                images.append(Image(._3))
            case "4":
                images.append(Image(._4))
            default:
                continue
            }
        }
        return images
    }
}
