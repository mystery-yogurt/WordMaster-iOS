import Foundation

public final class LocalStorageService {
    public static let shared = LocalStorageService()
    private let decksKey = "WordMaster_Decks_v1"
    private let cardsKey = "WordMaster_Cards_v1"
    
    private init() {}
    
    public func saveDecks(_ decks: [Deck]) {
        if let encoded = try? JSONEncoder().encode(decks) {
            UserDefaults.standard.set(encoded, forKey: decksKey)
        }
    }
    
    public func loadDecks() -> [Deck]? {
        guard let data = UserDefaults.standard.data(forKey: decksKey),
              let decoded = try? JSONDecoder().decode([Deck].self, from: data) else {
            return nil
        }
        return decoded
    }
    
    public func saveCards(_ cards: [WordCard]) {
        if let encoded = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(encoded, forKey: cardsKey)
        }
    }
    
    public func loadCards() -> [WordCard]? {
        guard let data = UserDefaults.standard.data(forKey: cardsKey),
              let decoded = try? JSONDecoder().decode([WordCard].self, from: data) else {
            return nil
        }
        return decoded
    }
}
