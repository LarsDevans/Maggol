//
//  DataServiceTests.swift
//  MaggolTests
//
//  Created by Lars Beijaard on 19/02/2025.
//

import Testing
import SwiftData

@MainActor
struct DataServiceTests {

    @Test("Data successfully stored in memory", arguments: [
        Dummy(name: "John Doe"),
        Dummy(name: "Jane Doe")
    ])
    func dataSuccesfullyStoredInMemory(dataModel: Dummy) async throws {
        let dataService = DataService.inMemory
        dataService.container.mainContext.insert(dataModel)
        
        let fetchedDataModel = try dataService.container.mainContext.fetch(FetchDescriptor<Dummy>())
        
        #expect(dataService.container.mainContext.hasChanges)
        #expect(fetchedDataModel.first?.name == dataModel.name)
    }

}
