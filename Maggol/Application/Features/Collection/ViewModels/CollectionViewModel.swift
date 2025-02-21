//
//  CollectionViewModel.swift
//  Maggol
//
//  Created by Lars Beijaard on 20/02/2025.
//

import Foundation

final class CollectionViewModel: ObservableObject, FetchCardDelegate {
    @Published var isAddingCard: Bool = false
    
    private(set) var cards: [Card]
    
    convenience init() {
        self.init(cards: [])
    }
    
    init(cards: [Card]) {
        self.cards = cards
    }
    
    func update(with card: Card) {
        cards.append(card)
    }
}
