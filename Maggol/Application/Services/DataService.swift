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
            let config = ModelConfiguration(isStoredInMemoryOnly: !persistent)
            container = try ModelContainer(for: Dummy.self, configurations: config)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
}
