//
//  DataService.swift
//  Maggol
//
//  Created by Lars Beijaard on 19/02/2025.
//

import Foundation
import SwiftData

final class DataService {
    static let persistent: DataService = {
        DataService()
    }()

    static let inMemory: DataService = {
        DataService(persistent: false)
    }()
    
    let container: ModelContainer
    
    private init(persistent: Bool = true) {
        do {
            let schema = Schema([Card.self, CardImage.self])
            let config = ModelConfiguration(isStoredInMemoryOnly: !persistent)
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to initialize ModelContainer. You may need to reinstall the app: \(error)")
        }
    }
    
    @MainActor
    func save() async {
        if container.mainContext.hasChanges {
            try? container.mainContext.save()
        }
    }
}
