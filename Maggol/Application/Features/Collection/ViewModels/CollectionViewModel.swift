//
//  CollectionViewModel.swift
//  Maggol
//
//  Created by Lars Beijaard on 20/02/2025.
//

import Combine
import Foundation
import SwiftUI

final class CollectionViewModel: ObservableObject {
    @Published var isAddingCard: Bool = false
    @Published var searchQuery: String = ""

    @Published var cards: [Card] = []
    @ObservedObject var cardController: CardController
    private var cancellables = Set<AnyCancellable>()
    
    var filteredCards: [Card] {
        if searchQuery.isEmpty {
            return cards
        }

        return cards.filter {
            $0.name.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    convenience init() {
        self.init(cardController: CardController.shared)
    }
    
    init(cardController: CardController) {
        self.cardController = cardController
        self.cardController.$cards
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updated in
                self?.cards = updated
            }
            .store(in: &cancellables)
    }
    
    func removeCard(at indexSet: IndexSet) {
        for index in indexSet {
            cardController.remove(at: index)
        }
    }
}
