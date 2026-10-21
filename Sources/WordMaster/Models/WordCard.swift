import Foundation

public struct WordCard: Identifiable, Codable {
    public var id: UUID
    public var word: String
    public var transcription: String
    public var translation: String
    public var exampleSentence: String
    public var deckId: UUID
    
    // Параметры алгоритма SuperMemo SM-2
    public var repetitions: Int
    public var intervalDays: Int
    public var easinessFactor: Double // EF (по умолчанию 2.5)
    public var nextReviewDate: Date
    
    public init(
        id: UUID = UUID(),
        word: String,
        transcription: String,
        translation: String,
        exampleSentence: String,
        deckId: UUID,
        repetitions: Int = 0,
        intervalDays: Int = 1,
        easinessFactor: Double = 2.5,
        nextReviewDate: Date = Date()
    ) {
        self.id = id
        self.word = word
        self.transcription = transcription
        self.translation = translation
        self.exampleSentence = exampleSentence
        self.deckId = deckId
        self.repetitions = repetitions
        self.intervalDays = intervalDays
        self.easinessFactor = easinessFactor
        self.nextReviewDate = nextReviewDate
    }
    
    // Вычисляемый уровень запоминания от 0 до 5
    public var memoryLevel: Int {
        min(5, max(0, repetitions))
    }
    
    // Готово ли слово к повторению прямо сейчас
    public var isDueForReview: Bool {
        nextReviewDate <= Date()
    }
}
