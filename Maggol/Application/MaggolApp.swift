//
//  MaggolApp.swift
//  Maggol
//
//  Created by Lars Beijaard on 07/02/2025.
//

import SwiftUI
import SwiftData

@main
struct MaggolApp: App {
    init() {
        NotificationService().activate()
    }

    var body: some Scene {
        WindowGroup {
            CollectionView(viewModel: CollectionViewModel())
        }
    }
}
