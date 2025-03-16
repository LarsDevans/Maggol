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
    
    func edit(with originalCard: Card, updatedCard: Card) {
        Task {
            await editCard(originalCard: originalCard, updatedCard: updatedCard)
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
            cardToUpdate.amount += card.amount
        } else {
            cards.append(card)
            dataService.container.mainContext.insert(card)
        }
        
        await dataService.save()
    }
    
    @MainActor
    func editCard(originalCard: Card, updatedCard: Card) async {
        guard let existingCardIndex = cards.firstIndex(where: { $0.applicationCardId == updatedCard.applicationCardId }) else {
            replaceCard(originalCard, with: updatedCard)
            await dataService.save()
            return
        }

        let existingCard = cards[existingCardIndex]
        
        if originalCard.foil == updatedCard.foil {
            existingCard.amount = updatedCard.amount
        } else {
            existingCard.amount += updatedCard.amount
            removeOriginalCardIfNeeded(originalCard, existingCard)
        }

        cards[existingCardIndex] = existingCard
        await dataService.save()
    }

    @MainActor
    func replaceCard(_ originalCard: Card, with updatedCard: Card) {
        if let originalIndex = cards.firstIndex(where: { $0 === originalCard }) {
            dataService.container.mainContext.delete(originalCard)
            dataService.container.mainContext.insert(updatedCard)
            
            cards[originalIndex] = updatedCard
        }
    }

    @MainActor
    func removeOriginalCardIfNeeded(_ originalCard: Card, _ existingCard: Card) {
        guard originalCard !== existingCard else { return }
        
        dataService.container.mainContext.delete(originalCard)
        
        if let originalIndex = cards.firstIndex(where: { $0 === originalCard }) {
            cards.remove(at: originalIndex)
        }
    }
}
