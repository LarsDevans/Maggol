import Foundation
import UIKit

class ManaSymbolConverter {
    static let shared = ManaSymbolConverter()
    
    private var symbols: [String: CardSymbol] = [:]
        
    private init() {
        Task {
            symbols = await fetchAllManaSymbols()
        }
    }
    
    func fetchAllManaSymbols() async -> [String: CardSymbol] {
        let rawURL = "http://api.scryfall.com/symbology"
        guard let url = URL(string: rawURL) else { return [:] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SymbolListResponse.self, from: data)
            return Dictionary(uniqueKeysWithValues: response.data.map { ($0.symbol, $0) })
        } catch {
            print("Error fetching mana symbols: \(error)")
            return [:]
        }
    }
    
}

// MARK: - Public API
extension ManaSymbolConverter {
    func convert(text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        processSymbols(in: attributedString)
        return attributedString
    }
}

// MARK: - Private Implementation
private extension ManaSymbolConverter {
    func processSymbols(in attributedString: NSMutableAttributedString) {
        let matches = symbols.keys.filter { key in
            guard attributedString.string.range(of: key) != nil else { return false }
            return attributedString.string.range(of: key, options: .regularExpression) != nil
        }
        
        for match in matches.reversed() {
            // TODO
        }
    }
}

struct SymbolListResponse: Codable {
    let object: String
    let has_more: Bool
    let data: [CardSymbol]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        object = try container.decode(String.self, forKey: .object)
        has_more = try container.decode(Bool.self, forKey: .has_more)
        data = try container.decode([CardSymbol].self, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case object
        case has_more
        case data
    }
}

struct CardSymbol: Codable {
    let symbol: String
    let svgUri: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        symbol = try container.decode(String.self, forKey: .symbol)
        svgUri = try container.decode(String.self, forKey: .svgUri)
    }
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case svgUri = "svg_uri"
    }
}
