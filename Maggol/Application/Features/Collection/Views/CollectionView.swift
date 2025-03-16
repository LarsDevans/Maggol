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
            .searchable(
                text: $viewModel.searchQuery,
                prompt: "Zoek naar een kaart"
            )
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
            if viewModel.filteredCards.isEmpty {
                searchEmptyState
            } else {
                populatedState
            }
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
        ForEach(viewModel.filteredCards, id: \.applicationCardId) { card in
            NavigationLink(
                destination: CardDetailView(viewModel: cardViewModel, card: card)
            ) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(card.name) \(card.foil ? " ٭" : "")")
                    }
                    
                    Spacer()
                    
                    if card.amount > 1 {
                        Text("\(card.amount)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Collectie")
        }
        .onDelete { indexSet in
            viewModel.removeCard(at: indexSet)
        }
    }
    
    private var searchEmptyState: some View {
        ContentUnavailableView {
            Label("Geen kaarten gevonden", systemImage: "magnifyingglass")
        } description: {
            Text("Zorg dat de kaart in je collectie zit of controleer de zoekopdracht!")
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
    let cardController = CardController(cards: [], dataService: .inMemory)
    let viewModel = CollectionViewModel(cardController: cardController)
    CollectionView(viewModel: viewModel)
}

#Preview("Populated state") {
    let cards: [Card] = [
        .init(
            id: "991270fa-a391-4c2e-bd9a-19151386fb67",
            name: "Basri, Tomorrow's Champion",
            imageURL: CardImage(
                normal: "https://cards.scryfall.io/normal/front/9/9/991270fa-a391-4c2e-bd9a-19151386fb67.jpg?1738356108",
                artCrop: "https://cards.scryfall.io/art_crop/front/9/9/991270fa-a391-4c2e-bd9a-19151386fb67.jpg?1738356108"
            ),
            typeLine: "Legendary Creature — Human Knight",
            manaCost: "{W}",
            oracleText: "{W}, {T}, Exert Basri: Create a 1/1 white Cat creature token with lifelink. (An exerted creature won't untap during your next untap step.)\nCycling {2}{W} ({2}{W}, Discard this card: Draw a card.)\nWhen you cycle this card, Cats you control gain hexproof and indestructible until end of turn.",
            setName: "Aetherdrift",
            set: "dft",
            collectorNumber: "3",
            rarity: "rare",
            power: "2",
            toughness: "1",
            keywords: [
                "Cycling"
            ],
            foil: true,
            amount: 2
        ),
        .init(
            id: "7eb819eb-ba5c-4449-87b5-3894380558bc",
            name: "Brightfield Glider",
            imageURL: CardImage(
                normal: "https://cards.scryfall.io/normal/front/7/e/7eb819eb-ba5c-4449-87b5-3894380558bc.jpg?1738356111",
                artCrop:  "https://cards.scryfall.io/art_crop/front/7/e/7eb819eb-ba5c-4449-87b5-3894380558bc.jpg?1738356111"
            ),
            typeLine: "Creature — Possum Mount",
            manaCost: "{W}",
            oracleText: "Vigilance\nWhenever this creature attacks while saddled, it gets +1/+2 and gains flying until end of turn.\nSaddle 3 (Tap any number of other creatures you control with total power 3 or more: This Mount becomes saddled until end of turn. Saddle only as a sorcery.)",
            setName: "Aetherdrift",
            set: "dft",
            collectorNumber: "4",
            rarity: "common",
            power: "1",
            toughness: "1",
            keywords: [
                "Saddle",
                "Vigilance"
            ],
            amount: 1
        ),
        .init(
            id: "b2c7cacc-f15e-46c1-9c25-b567bb3e8680",
            name: "Brightfield Mustang",
            imageURL: CardImage(
                normal: "https://cards.scryfall.io/normal/front/b/2/b2c7cacc-f15e-46c1-9c25-b567bb3e8680.jpg?1738356112",
                artCrop:  "https://cards.scryfall.io/art_crop/front/b/2/b2c7cacc-f15e-46c1-9c25-b567bb3e8680.jpg?1738356112"
            ),
            typeLine: "Creature — Horse Mount",
            manaCost: "{3}{W}",
            oracleText: "Whenever this creature attacks while saddled, untap it and put a +1/+1 counter on it.\nSaddle 1 (Tap any number of other creatures you control with total power 1 or more: This Mount becomes saddled until end of turn. Saddle only as a sorcery.)",
            setName: "Aetherdrift",
            set: "dft",
            collectorNumber: "5",
            rarity: "common",
            power: "3",
            toughness: "3",
            keywords: [
                "Saddle"
            ],
            amount: 1
        ),
        .init(
            id: "89ce2385-e33d-47b3-96c8-5a4672d9df7c",
            name: "Bulwark Ox",
            imageURL: CardImage(
                normal: "https://cards.scryfall.io/normal/front/1/0/106944b2-f3ae-4350-be33-61b9f92fc92f.jpg?1738356118",
                artCrop:  "https://cards.scryfall.io/art_crop/front/1/0/106944b2-f3ae-4350-be33-61b9f92fc92f.jpg?1738356118"
            ),
            typeLine: "Artifact — Vehicle",
            manaCost: "{4}{W}",
            oracleText: "When this Vehicle enters, create a 1/1 colorless Thopter artifact creature token with flying.\nCrew 1 (Tap any number of creatures you control with total power 1 or more: This Vehicle becomes an artifact creature until end of turn.)",
            setName: "Aetherdrift",
            set: "dft",
            collectorNumber: "6",
            rarity: "common",
            power: "5",
            toughness: "4",
            keywords: [
                "Crew"
            ],
            foil: true,
            amount: 7
        ),
        .init(
            id: "106944b2-f3ae-4350-be33-61b9f92fc92f",
            name: "Canyon Vaulter",
            imageURL: CardImage(
                normal: "https://cards.scryfall.io/normal/front/c/c/cc0b15da-a45c-42f5-aafc-20ad9e38bf24.jpg?1738356122",
                artCrop:  "https://cards.scryfall.io/art_crop/front/c/c/cc0b15da-a45c-42f5-aafc-20ad9e38bf24.jpg?1738356122"
            ),
            typeLine: "Creature — Ox Mount",
            manaCost: "{1}{W}",
            oracleText: "Whenever this creature attacks while saddled, put a +1/+1 counter on target creature.\nSacrifice this creature: Creatures you control with counters on them gain hexproof and indestructible until end of turn.\nSaddle 1 (Tap any number of other creatures you control with total power 1 or more: This Mount becomes saddled until end of turn. Saddle only as a sorcery.)",
            setName: "Aetherdrift",
            set: "dft",
            collectorNumber: "7",
            rarity: "rare",
            power: "2",
            toughness: "2",
            keywords: [
                "Saddle"
            ],
            amount: 4
        )
    ]
    let cardController = CardController(cards: cards, dataService: .inMemory)
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

