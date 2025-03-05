//
//  CardViewModel.swift
//  Maggol
//
//  Created by Lars Beijaard on 20/02/2025.
//

import Foundation
import SwiftUI

final class CardViewModel: ObservableObject {
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
    
    var delegate: FetchCardDelegate? = nil
    
    private let magicService: MagicService
    private let manaSymbolConverter: ManaSymbolConverter
    
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
        manaSymbolConverter = ManaSymbolConverter()
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
        let result = manaSymbolConverter.convertManaCost(manaCost: manaCost)
        return result
    }
    
    func submit() {
        guard let card = fetchedCard else { return }
        delegate?.update(with: card)
    }
}
