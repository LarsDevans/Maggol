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
}
