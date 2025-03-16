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
        if let existingCardIndex = cards.firstIndex(where: { $0.applicationCardId == updatedCard.applicationCardId }) {
            let existingCard = cards[existingCardIndex]
            
            if originalCard.foil == updatedCard.foil {
                originalCard.amount = updatedCard.amount
                await dataService.save()
                return
            }
            
            existingCard.amount += updatedCard.amount
            
            if originalCard !== existingCard {
                dataService.container.mainContext.delete(originalCard)
                
                if let originalIndex = cards.firstIndex(where: { $0 === originalCard }) {
                    cards.remove(at: originalIndex)
                }
            }
            
            if let existingCardIndex = cards.firstIndex(where: { $0 === existingCard }) {
                cards[existingCardIndex] = existingCard
            }
        } else {
            if let originalIndex = cards.firstIndex(where: { $0 === originalCard }) {
                dataService.container.mainContext.delete(originalCard)
                dataService.container.mainContext.insert(updatedCard)
                
                cards.remove(at: originalIndex)
                cards.append(updatedCard)
            }
        }
        
        await dataService.save()
    }
}
