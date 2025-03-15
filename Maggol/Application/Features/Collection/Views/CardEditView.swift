//
//  CardEditView.swift
//  Maggol
//
//  Created by Linde Rus on 15/03/2025.
//

import SwiftUI

struct CardEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    var viewModel: CardViewModel
    @State var card: Card
    
    var body: some View {
        Form {
            Section("Kaart informatie") {
                cardInformation
            }
            
            Section {
                cardEditAction
            }
        }
    }
}

private extension CardEditView {
    @ViewBuilder
    var cardInformation: some View {
        TextField(
            "Aantal",
            value: $card.amount,
            format: .number
        )
        .keyboardType(.numberPad)
        
        Toggle(isOn: $card.foil) {
            Text("Foil-kaart inschakelen")
        }
    }
    
    var cardEditAction: some View {
        Button(action: {
            viewModel.edit(card: card)
            dismiss()
        }) {
            Text("Wijzigingen opslaan")
        }
    }
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
    CardEditView(viewModel: viewModel, card: card)
}
