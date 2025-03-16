//
//  CardController.swift
//  Maggol
//
//  Created by Lars Beijaard on 21/02/2025.
//

import Foundation
import SwiftData

final class CardController: ObservableObject, CardDelegate {
    static let shared = CardController()
    
    @Published private(set) var cards: [Card] = []
    
    private let dataService: DataService
    
    convenience init() {
        self.init(cards: [])
    }
    
    init(cards: [Card], dataService: DataService = .persistent) {
        self.dataService = dataService
        
        Task {
            for card in cards {
                await addCard(card)
            }
        }
    }
    
    @MainActor
    func loadFromMemory() async {
        let fetchRequest = FetchDescriptor<Card>()
        let fetchedCards = try? dataService.container.mainContext.fetch(fetchRequest)
        
        if let fetchedCards {
            cards = fetchedCards
        }
    }
    
    func update(with card: Card) {
        Task {
            await addCard(card)
        }
    }
    
    func edit(with originalCard: Card, forCopy: Card) {
        Task {
            await editCard(originalCard: originalCard, updatedCard: forCopy)
        }
    }
    
    @MainActor
    func remove(at index: Int) {
        guard cards.count > index else { return }
        
        dataService.container.mainContext.delete(cards[index])
        Task {
            await dataService.save()
        }
        
        cards.remove(at: index)
    }
}

private extension CardController {
    @MainActor
    func addCard(_ card: Card) async {
        if let cardToUpdate = cards.first(where: { $0 == card }) {
            cardToUpdate.amount += 1
        } else {
            cards.append(card)
            dataService.container.mainContext.insert(card)
        }
        
        await dataService.save()
    }
    
    @MainActor
    func editCard(originalCard: Card, updatedCard: Card) async {
        if originalCard.foil == updatedCard.foil {
            originalCard.amount = updatedCard.amount
        } else {
            if let index = cards.firstIndex(where: { $0.id == updatedCard.id && $0.foil == updatedCard.foil }) {
                cards[index].amount += updatedCard.amount
                originalCard.amount -= updatedCard.amount
            } else {
                originalCard.amount = updatedCard.amount
                originalCard.foil = updatedCard.foil
            }
        }
        
        if originalCard.amount <= 0 {
            dataService.container.mainContext.delete(originalCard)
        }

        Task {
            await dataService.save()
            await loadFromMemory() // Hotfix: this could be more performant
        }
    }
}
