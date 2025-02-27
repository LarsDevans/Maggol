//
//  CardDetailView.swift
//  Maggol
//
//  Created by Linde on 27/02/2025.
//

import SwiftUI

struct CardDetailView: View {
    let card: Card
    
    var body: some View {
        ScrollView {
            ZStack {
                AsyncImage(url: URL(string: card.imageURL.artCrop)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .overlay(.black.opacity(0.3))
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
                                .foregroundStyle(.white.opacity(0.8))
                                .font(.caption)
                        }
                        Spacer()
                        HStack(spacing: 2) {
                            Image(.cMana)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Image(.wMana)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Image(.bMana)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Image(.gMana)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Image(.uMana)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Image(.rMana)
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
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
        rarity: "mythic"
    )
    
    CardDetailView(card: card)
}
