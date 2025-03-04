import Foundation

class ManaSymbolConverter {
    private var symbols: [String: String] = [:]
    private let magicService: MagicService
    
    init(magicService: MagicService) {
        self.magicService = magicService
        
        Task {
            symbols = await magicService.fetchAllManaSymbols()
        }
    }
    
    func convertManaCost(text: String) -> [String] {
        guard !text.isEmpty else { return [] }
        
        let pattern = /\{([A-Z\/0-9∞½]+)\}/

        var uris: [String] = []
        
        for match in text.matches(of: pattern) {
            let symbol = match.1
            if let uri = symbols["{\(symbol)}"] {
                uris.append(uri)
            }
        }
        
        return uris
    }
}
