//
//  CollectionViewModel.swift
//  Maggol
//
//  Created by Lars Beijaard on 20/02/2025.
//

import Foundation

final class CollectionViewModel: ObservableObject {
    @Published var isAddingCard: Bool = false
    
    private(set) var cards: [Card]
    
    convenience init() {
        self.init(cards: [])
    }
    
    init(cards: [Card]) {
        self.cards = cards
    }
}
