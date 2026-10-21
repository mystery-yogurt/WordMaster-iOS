import Foundation
import Combine

public final class WordEventBroker {
    public static let shared = WordEventBroker()
    
    // Реактивный брокер входящих распознанных слов
    public let scannedWordSubject = PassthroughSubject<String, Never>()
    
    private init() {}
    
    public func sendScannedWord(_ word: String) {
        scannedWordSubject.send(word)
    }
}
