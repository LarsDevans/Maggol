//
//  CollectionView.swift
//  Maggol
//
//  Created by Lars Beijaard on 19/02/2025.
//

import SwiftUI

struct CollectionView: View {
    @ObservedObject private(set) var viewModel: CollectionViewModel
    private let cardViewModel: CardViewModel
    
    init(viewModel: CollectionViewModel) {
        self.viewModel = viewModel
        
        cardViewModel = .init()
        cardViewModel.delegate = CardController.shared
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    stateContent
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolbarToggleSheetAction
                }
            }
            .sheet(isPresented: $viewModel.isAddingCard) {
                createCardSheet
            }
            .navigationTitle("Collectie")
        }
        .onAppear {
            Task {
                await viewModel.cardController.loadFromMemory()
            }
        }
    }
}

// MARK: - Private computed variables

private extension CollectionView {
    @ViewBuilder
    private var stateContent: some View {
        if viewModel.cards.isEmpty {
            emptyState
        } else {
            populatedState
        }
    }
    
    private var emptyState: some View {
        ContentUnavailableView {
            Label("Je collectie is nog leeg", systemImage: "rectangle.stack")
        } description: {
            Text("Voeg je eerste kaart toe en begin met verzamelen!")
        }
    }
    
    private var populatedState: some View {
        ForEach(viewModel.cards) { card in
            NavigationLink(
                destination: CardDetailView(card: card)
            ) { Text(card.name) }
                .navigationTitle("Collectie")
        }
    }
    
    private var toolbarToggleSheetAction: some View {
        Button(action: {
            viewModel.isAddingCard.toggle()
        }) {
            Label("Toevoegen", systemImage: "plus")
        }
    }
    
    private var createCardSheet: some View {
        CardCreateView(viewModel: cardViewModel)
            .presentationDragIndicator(.visible)
    }
}

#Preview("Empty state") {
    let viewModel = CollectionViewModel()
    CollectionView(viewModel: viewModel)
}

#Preview("Populated state") {
    let cards: [Card] = [
        .init(
            id: "1",
            name: "Basri, Tomorrow's Champion",
            imageURL: CardImage(
                normal: "https://cards.scryfall.io/normal/front/9/9/991270fa-a391-4c2e-bd9a-19151386fb67.jpg?1738356108",
                artCrop: "https://cards.scryfall.io/art_crop/front/9/9/991270fa-a391-4c2e-bd9a-19151386fb67.jpg?1738356108"
            ),
            typeLine: "Legendary Creature — Human Knight"
        ),
        .init(
            id: "2",
            name: "Brightfield Glider",
            imageURL: CardImage(
                normal: "https://cards.scryfall.io/normal/front/7/e/7eb819eb-ba5c-4449-87b5-3894380558bc.jpg?1738356111",
                artCrop:  "https://cards.scryfall.io/art_crop/front/7/e/7eb819eb-ba5c-4449-87b5-3894380558bc.jpg?1738356111"
            ),
            typeLine: "Creature — Possum Mount"
        ),
        .init(
            id: "3",
            name: "Brightfield Mustang",
            imageURL: CardImage(
                normal: "https://cards.scryfall.io/normal/front/b/2/b2c7cacc-f15e-46c1-9c25-b567bb3e8680.jpg?1738356112",
                artCrop:  "https://cards.scryfall.io/art_crop/front/b/2/b2c7cacc-f15e-46c1-9c25-b567bb3e8680.jpg?1738356112"
            ),
            typeLine: "Creature — Horse Mount"
        ),
        .init(
            id: "4",
            name: "Bulwark Ox",
            imageURL: CardImage(
                normal: "https://cards.scryfall.io/normal/front/1/0/106944b2-f3ae-4350-be33-61b9f92fc92f.jpg?1738356118",
                artCrop:  "https://cards.scryfall.io/art_crop/front/1/0/106944b2-f3ae-4350-be33-61b9f92fc92f.jpg?1738356118"
            ),
            typeLine: "Artifact — Vehicle"
        ),
        .init(
            id: "5",
            name: "Canyon Vaulter",
            imageURL: CardImage(
                normal: "https://cards.scryfall.io/normal/front/c/c/cc0b15da-a45c-42f5-aafc-20ad9e38bf24.jpg?1738356122",
                artCrop:  "https://cards.scryfall.io/art_crop/front/c/c/cc0b15da-a45c-42f5-aafc-20ad9e38bf24.jpg?1738356122"
            ),
            typeLine: "Creature — Ox Mount"
        )
    ]
    let cardController = CardController(cards: cards)
    let viewModel = CollectionViewModel(cardController: cardController)
    CollectionView(viewModel: viewModel)
}

#Preview("Create card sheet") {
    let viewModel = CollectionViewModel()
    CollectionView(viewModel: viewModel)
        .task {
            viewModel.isAddingCard.toggle()
        }
}

