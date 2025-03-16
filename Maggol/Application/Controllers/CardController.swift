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
        print("originalCard: amount \(originalCard.amount), foil \(originalCard.foil)")
        print("updatedCard: amount \(updatedCard.amount), foil \(updatedCard.foil)")
        
        // Als updatedCard.applicationId al in de cards lijst staat
            // ExistingCard = de kaart met hetzelfde applicationId als updatedCard.applicationId
            // Verhoog de amount van ExistingCard met het amount van updatedCard
            // Verwijder originalcard uit de cards collectie
        
        // Anders originalCard opzoeken in de cards lijst
            // originalcard vervangen met updatedCard
        
        // Zoek naar een bestaande kaart met dezelfde applicationId
        if let existingCardIndex = cards.firstIndex(where: { $0.applicationCardId == updatedCard.applicationCardId }) {
            let existingCard = cards[existingCardIndex]
            print(existingCard.amount)
            
            // Update de hoeveelheid van de bestaande kaart
            existingCard.amount += updatedCard.amount
            print(existingCard.amount)
            
            // Verwijder de originele kaart alleen als het niet dezelfde kaart is
            if originalCard !== existingCard {
                print("test")
                if let originalIndex = cards.firstIndex(where: { $0 === originalCard }),
                   originalIndex != existingCardIndex {
                    cards.remove(at: originalIndex)
                }
            }
        } else {
            print("test2")
            // Vervang de originele kaart met de geüpdatete versie
            if let originalIndex = cards.firstIndex(where: { $0 === originalCard }) {
                cards[originalIndex] = updatedCard
            }
        }
        
        await dataService.save()
    }
}
