//
//  CardViewModel.swift
//  Maggol
//
//  Created by Lars Beijaard on 20/02/2025.
//

import Foundation

final class CardViewModel: ObservableObject {
    @Published var addCardSetPrompt: String
    @Published var addCardNumberPrompt: Int?
    @Published var addCardFoil: Bool = false
    @Published var fetchedCard: Card?
    
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
    }
}
