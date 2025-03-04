//
//  MagicService.swift
//  Maggol
//
//  Created by Lars Beijaard on 20/02/2025.
//

import Foundation

final class MagicService {
    static let shared: MagicService = {
        .init()
    }()
    
    private let rawBaseURL = "https://api.scryfall.com"
    
    func fetchCard(set: String, number: Int) async -> Card? {
        let rawURL = "\(rawBaseURL)/cards/\(set)/\(number)"
        guard let url = URL(string: rawURL) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedCard = try JSONDecoder().decode(Card.self, from: data)
            return decodedCard
        } catch {
            return nil
        }
    }
    
    func fetchAllManaSymbols() async -> [String: String] {
        let rawURL = "\(rawBaseURL)/symbology"
        guard let url = URL(string: rawURL) else { return [:] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SymbolListResponse.self, from: data)
            
            return Dictionary(uniqueKeysWithValues:
                response.data.compactMap { symbol in
                    guard let uri = URL(string: symbol.svgUri) else { return nil }
                    return (symbol.symbol, uri.absoluteString)
                }
            )
        } catch {
            print("Error fetching mana symbols: \(error)")
            return [:]
        }
    }
}

struct SymbolListResponse: Codable {
    let object: String
    let hasMore: Bool
    let data: [CardSymbol]
    
    enum CodingKeys: String, CodingKey {
        case object
        case hasMore = "has_more"
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        hasMore = try container.decode(Bool.self, forKey: .hasMore)
        data = try container.decode([CardSymbol].self, forKey: .data)
    }
}

struct CardSymbol: Codable {
    let symbol: String
    let svgUri: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        symbol = try container.decode(String.self, forKey: .symbol)
        svgUri = try container.decode(String.self, forKey: .svgUri)
    }
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case svgUri = "svg_uri"
    }
}
