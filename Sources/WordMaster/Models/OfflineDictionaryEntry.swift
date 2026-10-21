import Foundation

public struct OfflineDictionaryEntry: Identifiable, Codable {
    public var id: String
    public var word: String
    public var transcription: String
    public var translation: String
    public var example: String
    
    public init(id: String, word: String, transcription: String, translation: String, example: String) {
        self.id = id
        self.word = word
        self.transcription = transcription
        self.translation = translation
        self.example = example
    }
}
