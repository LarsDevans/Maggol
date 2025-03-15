//
//  CardEditView.swift
//  Maggol
//
//  Created by Linde Rus on 15/03/2025.
//

import SwiftUI

struct CardEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: CardViewModel
    
    var body: some View {
        Form {
            if let card = viewModel.cardToEdit {
                Section("Kaart informatie") {
                    cardInformation(card: card)
                }
                
                Section {
                    cardEditAction
                }
            } else {
                Text("Oeps! Er lijkt iets mis te gaan...\nGeen kaart geselecteerd!")
            }
        }
    }
}

private extension CardEditView {
    @ViewBuilder
    func cardInformation(card: Card) -> some View {
        TextField(
            "Aantal",
            value: Binding(
                get: { card.amount },
                set: { viewModel.cardToEdit?.amount = $0 }
            ),
            format: .number
        )
        .keyboardType(.numberPad)
        
        Toggle(isOn: Binding(
            get: { card.foil },
            set: { viewModel.cardToEdit?.foil = $0 }
        )) {
            Text("Foil-kaart inschakelen")
        }
    }
    
    var cardEditAction: some View {
        Button(action: {
            viewModel.saveEdits()
            dismiss()
        }) {
            Text("Wijzigingen opslaan")
        }
    }
}

#Preview("Empty state") {
    let viewModel = CardViewModel()
    CardEditView(viewModel: viewModel)
}

#Preview("Populated state") {
    let cardImage = CardImage(
        normal: "https://cards.scryfall.io/normal/front/d/b/db80391f-1643-4b72-a397-d141bb5702ee.jpg?1696017328",
        artCrop: "https://cards.scryfall.io/art_crop/front/d/b/db80391f-1643-4b72-a397-d141bb5702ee.jpg?1696017328"
    )
    let card = Card(
        id: "db80391f-1643-4b72-a397-d141bb5702ee",
        name: "The One Ring",
        imageURL: cardImage,
        typeLine: "Legendary Artifact",
        manaCost: "{4}",
        oracleText: "Indestructible\nWhen The One Ring enters, if you cast it, you gain protection from everything until your next turn.\nAt the beginning of your upkeep, you lose 1 life for each burden counter on The One Ring.\n{T}: Put a burden counter on The One Ring, then draw a card for each burden counter on The One Ring.",
        setName: "The Lord of the Rings: Tales of Middle-earth",
        set: "ltr",
        collectorNumber: "246",
        rarity: "mythic",
        keywords: [
            "Indestructible"
        ]
    )
    let viewModel = CardViewModel()
    viewModel.edit(card: card)
    
    return CardEditView(viewModel: viewModel)
}
