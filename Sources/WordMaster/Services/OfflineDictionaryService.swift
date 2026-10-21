import Foundation

public final class OfflineDictionaryService {
    public static let shared = OfflineDictionaryService()
    
    // Базовый офлайн-словарь наиболее частых иностранных слов
    public let vocabulary: [OfflineDictionaryEntry] = [
        OfflineDictionaryEntry(
            id: "w1",
            word: "ubiquitous",
            transcription: "[juːˈbɪkwɪtəs]",
            translation: "вездесущий, повсеместный",
            example: "Smartphones have become ubiquitous in modern daily life."
        ),
        OfflineDictionaryEntry(
            id: "w2",
            word: "resilience",
            transcription: "[rɪˈzɪliəns]",
            translation: "устойчивость, стойкость",
            example: "The team showed great resilience during the crisis."
        ),
        OfflineDictionaryEntry(
            id: "w3",
            word: "ephemeral",
            transcription: "[ɪˈfemərəl]",
            translation: "мимолетный, эфемерный",
            example: "Fame in the internet age can be quite ephemeral."
        ),
        OfflineDictionaryEntry(
            id: "w4",
            word: "leverage",
            transcription: "[ˈliːvərɪdʒ]",
            translation: "эффективно использовать, рычаг",
            example: "We need to leverage new technology to improve performance."
        ),
        OfflineDictionaryEntry(
            id: "w5",
            word: "diligent",
            transcription: "[ˈdɪlɪdʒənt]",
            translation: "прилежный, усердный",
            example: "She is a diligent student who always finishes tasks on time."
        ),
        OfflineDictionaryEntry(
            id: "w6",
            word: "meticulous",
            transcription: "[məˈtɪkjələs]",
            translation: "дотошный, тщательный",
            example: "He did meticulous research before writing the report."
        )
    ]
    
    private init() {}
    
    public func lookup(word: String) -> OfflineDictionaryEntry? {
        let cleaned = word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return vocabulary.first { $0.word.lowercased() == cleaned }
    }
}
