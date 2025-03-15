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
    
    func edit(with card: Card) {
        Task {
            await editCard(card)
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
    func editCard(_ card: Card) async {
        if let oldCardId = cards.firstIndex(where: { $0.applicationCardId == card.applicationCardId}) {
            dataService.container.mainContext.delete(cards[oldCardId])
            dataService.container.mainContext.insert(card)
            await dataService.save()
        }
    }
}
