//
//  CollectionView.swift
//  Maggol
//
//  Created by Lars Beijaard on 19/02/2025.
//

import SwiftUI

struct CollectionView: View {
    private(set) var viewModel: CollectionViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    stateContent
                }
            }
            .navigationTitle("Collectie")
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
            NavigationLink {
                
            } label: {
                Text(card.name)
            }
        }
    }
}

#Preview("Empty state") {
    let viewModel = CollectionViewModel()
    CollectionView(viewModel: viewModel)
}

#Preview("Populated state") {
    let cards: [Card] = [
        .init(name: "Basri, Tomorrow's Champion"),
        .init(name: "Brightfield Glider"),
        .init(name: "Brightfield Mustang"),
        .init(name: "Bulwark Ox"),
        .init(name: "Canyon Vaulter")
    ]
    let viewModel = CollectionViewModel(cards: cards)
    CollectionView(viewModel: viewModel)
}
