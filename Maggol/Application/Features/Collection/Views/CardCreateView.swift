//
//  CardCreateView.swift
//  Maggol
//
//  Created by Lars Beijaard on 20/02/2025.
//

import SwiftUI

struct CardCreateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private(set) var viewModel: CardViewModel
    
    var body: some View {
        Form {
            Section("Kaart informatie") {
                cardInformation
            }
            
            Section("Kaart voorbeeldweergave") {
                stateContent
            }
            
            Section {
                cardSubmitAction
            }
        }
    }
}

private extension CardCreateView {
    @ViewBuilder
    var cardInformation: some View {
        TextField(
            "Set",
            text: $viewModel.addCardSetPrompt
        )
        .textCase(.uppercase)
        .autocorrectionDisabled()
        
        TextField(
            "Nummer",
            value: $viewModel.addCardNumberPrompt,
            format: .number
        )
        .keyboardType(.numberPad)
        
        Toggle(isOn: $viewModel.addCardFoil) {
            Text("Foil-kaart inschakelen")
        }
    }
    
    @ViewBuilder
    var stateContent: some View {
        if viewModel.fetchedCard == nil {
            emptyState
        } else {
            populatedState
        }
    }
    
    var emptyState: some View {
        ContentUnavailableView {
            Label("Welke kaart voeg je toe?", systemImage: "doc.text.magnifyingglass")
        } description: {
            Text("Voer de set en het kaartnummer in om je collectie uit te breiden.")
        }
    }
    
    var populatedState: some View {
        Group {
            if let card = viewModel.fetchedCard {
                AsyncImage(url: URL(string: card.imageURL.normal)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    populatedCardProgress
                }
            } else {
                populatedCardProgress
            }
        }
    }
    
    var populatedCardProgress: some View {
        ProgressView("Afbeelding aan het laden")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }
    
    var cardSubmitAction: some View {
        Button(action: {
            viewModel.submit()
            dismiss()
        }) {
            Text("Kaart toevoegen aan collectie")
        }
    }
}

#Preview("Empty state") {
    let viewModel = CardViewModel()
    CardCreateView(viewModel: viewModel)
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
    let viewModel = CardViewModel(
        addCardSetPrompt: "LTR",
        addCardNumberPrompt: 246,
        addCardFoil: true,
        fetchedCard: card
    )
    CardCreateView(viewModel: viewModel)
}
