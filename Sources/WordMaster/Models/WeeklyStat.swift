import Foundation

public struct WeeklyStat: Identifiable {
    public var id = UUID()
    public var day: String
    public var wordsLearned: Int
    
    public init(day: String, wordsLearned: Int) {
        self.day = day
        self.wordsLearned = wordsLearned
    }
}
