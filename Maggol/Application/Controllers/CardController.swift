//
//  CardController.swift
//  Maggol
//
//  Created by Lars Beijaard on 21/02/2025.
//

import Foundation
import SwiftData

final class CardController: ObservableObject, FetchCardDelegate {
    static let shared = CardController()
    
    @Published private(set) var cards: [Card]
    
    private let dataService: DataService
    
    convenience init(resetMemory: Bool = false) {
        self.init(cards: [])
        if resetMemory {
            Task { await self.resetMemory() }
        }
    }
    
    init(cards: [Card], resetMemory: Bool = false) {
        self.cards = cards
        dataService = DataService.persistent
        
        Task {
            if resetMemory {
                await self.resetMemory()
            }
            
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
    
    @MainActor
    func resetMemory() {
        do {
            let fetchRequest = FetchDescriptor<Card>()
            let objects = try dataService.container.mainContext.fetch(fetchRequest)
            for object in objects {
                dataService.container.mainContext.delete(object)
            }
            try dataService.container.mainContext.save()
        } catch {
            print("Error deleting data: \(error)")
        }
    }
    
    func update(with card: Card) {
        Task {
            await addCard(card)
        }
    }
}

private extension CardController {
    @MainActor
    func addCard(_ card: Card) async {
        if let cardToUpdate = cards.first(where: { $0 == card }) {
            cardToUpdate.amount += 1
            return
        }
        
        cards.append(card)
        dataService.container.mainContext.insert(card)
        
        await dataService.save()
    }
}
