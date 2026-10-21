import Foundation

public struct Deck: Identifiable, Codable {
    public var id: UUID
    public var title: String
    public var icon: String
    public var colorHex: String
    public var createdAt: Date
    
    public init(id: UUID = UUID(), title: String, icon: String, colorHex: String, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.icon = icon
        self.colorHex = colorHex
        self.createdAt = createdAt
    }
}
