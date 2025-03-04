//
//  CardDetailView.swift
//  Maggol
//
//  Created by Linde on 27/02/2025.
//

import SwiftUI

struct CardDetailView: View {
    let cardViewModel: CardViewModel
    let card: Card
    var manaSymbolUri: [String]
    
    init(cardViewModel: CardViewModel, card: Card) {
        self.cardViewModel = cardViewModel
        self.card = card
        
        manaSymbolUri = cardViewModel.translateManaCostToImage(manaCost: card.manaCost)
    }
    
    var body: some View {
        ScrollView {
            headerSection
            detailsSection
        }
        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension CardDetailView {
    @ViewBuilder
    var headerSection: some View {
        ZStack {
            AsyncImage(url: URL(string: card.imageURL.artCrop)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .overlay(.black.opacity(0.3))
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(card.name)
                            .bold()
                            .foregroundStyle(.white)
                        
                        Text(card.typeLine)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    Spacer()
                    
                    HStack(spacing: 2) {
                        ForEach(manaSymbolUri.indices, id: \.self) { index in
                            if let url = URL(string: manaSymbolUri[index]) {
                                SVGImage(url: url, size: CGSize(width: 20, height: 20))
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    var detailsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            let descriptionLines = card.oracleText.components(separatedBy: "\n")
            VStack(alignment: .leading) {
                Text("Beschrijving")
                    .bold()
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(descriptionLines, id: \.self) { line in
                        Text(line)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            Divider()
            SectionViewHorizontal(title: "Set", value: card.setName)
            Divider()
            SectionViewHorizontal(title: "Nummer", value: card.collectorNumber)
            Divider()
            SectionViewHorizontal(title: "Zeldzaamheid", value: card.rarity.capitalized)
            Divider()
            SectionViewHorizontal(title: "Trefwoorden", value: card.keywordStrings.joined(separator: ", "))
        }
        .padding()
    }
    
    struct SectionViewVertical: View {
        let title: String
        let value: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .bold()
                Text(value)
            }
        }
    }
    
    struct SectionViewHorizontal: View {
        let title: String
        let value: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 4) {
                Text(title)
                    .bold()
                Spacer()
                Text(value)
            }
        }
    }
}

#Preview {
    let cardImage = CardImage(
        normal: "https://cards.scryfall.io/normal/front/c/f/cf3320ec-c4e8-405a-982d-e009c58c9e21.jpg?1721426449",
        artCrop: "https://cards.scryfall.io/art_crop/front/c/f/cf3320ec-c4e8-405a-982d-e009c58c9e21.jpg?1721426449"
    )
    let card = Card(
        id: "db80391f-1643-4b72-a397-d141bb5702ee",
        name: "The One Ring",
        imageURL: cardImage,
        typeLine: "Legendary Artifact",
        manaCost: "{4}",
        oracleText: "Indestructible\nWhen The One Ring enters, if you cast it, you gain protection from everything until your next turn.\nAt the beginning of your upkeep, you lose 1 life for each burden counter on The One Ring.\n{T}: Put a burden counter on The One Ring, then draw a card for each burden counter on The One Ring.",
        setName: "The Lord of the Rings: Tales of Middle-earth",
        collectorNumber: "246",
        rarity: "mythic",
        keywords: [
            "Indestructible"
        ]
    )
    
    CardDetailView(cardViewModel: CardViewModel(), card: card)
}
