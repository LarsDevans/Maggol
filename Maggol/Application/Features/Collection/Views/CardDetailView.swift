//
//  CardDetailView.swift
//  Maggol
//
//  Created by Linde on 27/02/2025.
//

import SwiftUI

struct CardDetailView: View {
    @ObservedObject private(set) var viewModel: CardViewModel
    let manaCostImages: [Image]
    
    let card: Card
    
    init(viewModel: CardViewModel, card: Card) {
        self.viewModel = viewModel
        self.manaCostImages = viewModel.translateManaCost(manaCost: card.manaCost)
        
        self.card = card
    }
    
    var body: some View {
        ScrollView {
            headerSection
            detailsSection
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolbarToggleSheetAction
            }
        }
        .sheet(isPresented: $viewModel.isEditingCard) {
            editCardSheet
        }
        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension CardDetailView {
    var toolbarToggleSheetAction: some View {
        Button(action: {
            viewModel.edit(card: card)
            viewModel.isEditingCard.toggle()
        }) {
            Label("Wijzigen", systemImage: "pencil")
        }
    }
    
    private var editCardSheet: some View {
        return CardEditView(viewModel: viewModel)
            .presentationDragIndicator(.visible)
    }
}

// MARK: - Header Section
private extension CardDetailView {
    var headerSection: some View {
        ZStack {
            cardImage
            
            VStack(alignment: .leading) {
                Spacer()
                cardInfoOverlay
            }
            .padding()
        }
    }
    
    var cardImage: some View {
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
    }
    
    var cardInfoOverlay: some View {
        HStack(alignment: .bottom) {
            cardOverlayMeta
            Spacer()
            cardOverlayMana
        }
    }
    
    var cardOverlayMeta: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(card.name)
                .bold()
                .foregroundStyle(.white)
                .font(.title)
            
            Text(card.typeLine)
                .foregroundStyle(.white.opacity(0.8))
        }
    }
    
    var cardOverlayMana: some View {
        HStack(spacing: 2) {
            ForEach(manaCostImages.indices, id: \.self) { index in
                manaCostImages[index]
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }
}

// MARK: - Details Section
private extension CardDetailView {
    var detailsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            cardDescriptionSection
            Divider()
            metadataSections
        }
        .padding()
    }
    
    var cardDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Beschrijving")
                .bold()
            ForEach(card.oracleText.components(separatedBy: "\n"), id: \.self) { line in
                Text(line)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    var metadataSections: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionViewHorizontal(title: "Set", value: "\(card.setName) (\(card.set.uppercased()))")
            Divider()
            SectionViewHorizontal(title: "Nummer", value: card.collectorNumber)
            Divider()
            SectionViewHorizontal(title: "Foil kaart", value: card.foil ? "Ja" : "Nee")
            Divider()
            SectionViewHorizontal(title: "Zeldzaamheid", value: card.rarity.capitalized)
            powerAndToughnessSection
            Divider()
            keywordsSection
            Divider()
            SectionViewHorizontal(title: "Aantal", value: String(card.amount))
        }
    }
    
    var keywordsSection: some View {
        Group {
            if !card.keywordStrings.isEmpty {
                SectionViewHorizontal(title: "Trefwoorden",
                                      value: card.keywordStrings.joined(separator: ", "))
            } else {
                HStack(alignment: .top, spacing: 4) {
                    Text("Trefwoorden")
                        .bold()
                    Spacer()
                    Text("Geen trefwoorden").italic()
                }
            }
        }
    }
    
    @ViewBuilder
    var powerAndToughnessSection: some View {
        if let power = card.power {
            Divider()
            SectionViewHorizontal(title: "Kracht", value: power)
        }
        
        if let toughness = card.toughness {
            Divider()
            SectionViewHorizontal(title: "Verdediging", value: toughness)
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
        set: "ltr",
        collectorNumber: "246",
        rarity: "mythic",
        keywords: [
            "Indestructible"
        ]
    )
    
    CardDetailView(viewModel: CardViewModel(), card: card)
}
