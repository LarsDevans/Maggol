//
//  CardViewModel.swift
//  Maggol
//
//  Created by Lars Beijaard on 20/02/2025.
//

import Foundation
import SwiftUI

final class CardViewModel: ObservableObject {
    @Published var isEditingCard: Bool = false
    @Published var cardToEdit: Card? = nil
    
    @Published var addCardSetPrompt: String {
        didSet {
            Task {
                await fetchCard()
            }
        }
    }
    @Published var addCardNumberPrompt: Int? {
        didSet {
            Task {
                await fetchCard()
            }
        }
    }
    @Published var addCardFoil: Bool = false
    @Published var fetchedCard: Card?
    
    var delegate: CardDelegate? = nil
    
    private let magicService: MagicService
    
    init(
        addCardSetPrompt: String = "",
        addCardNumberPrompt: Int? = nil,
        addCardFoil: Bool = false,
        fetchedCard: Card? = nil
    ) {
        self.addCardSetPrompt = addCardSetPrompt
        self.addCardNumberPrompt = addCardNumberPrompt
        self.addCardFoil = addCardFoil
        self.fetchedCard = fetchedCard
        
        magicService = MagicService.shared
    }
    
    @MainActor
    func fetchCard() async {
        guard let addCardNumberPrompt else {
            fetchedCard = nil
            return
        }
        
        fetchedCard = await magicService.fetchCard(set: addCardSetPrompt, number: addCardNumberPrompt)
    }
    
    func translateManaCost(manaCost: String) -> [Image] {
        let result = ManaSymbol.asImageSerie(manaCost: manaCost)
        return result.compactMap { $0 }
    }
    
    func submit() {
        guard let card = fetchedCard else { return }
        card.foil = addCardFoil
        
        delegate?.update(with: card)
    }
    
    func edit(card: Card) {
        cardToEdit = card
    }
    
    func saveEdits() {
        if let card = cardToEdit, card.hasChanges {
            delegate?.edit(with: card)
        }
    }
}
