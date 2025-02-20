//
//  MagicServiceTests.swift
//  MaggolTests
//
//  Created by Lars Beijaard on 20/02/2025.
//

import Testing

struct MagicServiceTests {

    @Test("Card succesfully fetched from API", arguments: [
        ("BLB", 100, "Maha, Its Feathers Night"),
        ("BLB", 362, "Fecund Greenshell"),
        ("BLB", 304, "Kitsa, Otterball Elite")
    ])
    func cardSuccesfullyFetchedFromAPI(set: String, number: Int, expectedCardName: String) async throws {
        let magicService = MagicService.shared
        
        let card = await magicService.fetchCard(set: set, number: number)
        
        #expect(card?.name == expectedCardName)
    }
    
    @Test("Card unsuccesfully fetched from API", arguments: [
        ("LTR", Int.max),                   // Valid set : invalid number
        ("Invalid set", 10),                // Invalid set : valid number
        ("Another invalid set", Int.max),   // Invalid set : invalid number
    ])
    func cardUnsuccesfullyFetchedFromAPI(set: String, number: Int) async throws {
        let magicService = MagicService.shared
        
        let card = await magicService.fetchCard(set: set, number: number)
        
        #expect(card == nil)
    }

}
