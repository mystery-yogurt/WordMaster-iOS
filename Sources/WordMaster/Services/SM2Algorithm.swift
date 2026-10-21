import Foundation

public struct SM2CalculationResult {
    public let nextReviewDate: Date
    public let intervalDays: Int
    public let repetitions: Int
    public let easinessFactor: Double
}

public final class SM2Algorithm {
    /// Расчет по формуле SuperMemo SM-2
    /// quality: оценка ответа от 0 (забыл) до 5 (отлично помню)
    public static func calculate(card: WordCard, quality: Int) -> SM2CalculationResult {
        var reps = card.repetitions
        var interval = card.intervalDays
        var ef = card.easinessFactor
        
        let q = Double(max(0, min(5, quality)))
        
        // 1. Модификация коэффициента легкости EF
        ef = ef + (0.1 - (5.0 - q) * (0.08 + (5.0 - q) * 0.02))
        if ef < 1.3 {
            ef = 1.3
        }
        
        // 2. Расчет интервала
        if quality >= 3 {
            if reps == 0 {
                interval = 1
            } else if reps == 1 {
                interval = 6
            } else {
                interval = Int(round(Double(interval) * ef))
            }
            reps += 1
        } else {
            // Если слово не вспомнили — сброс цикла
            reps = 0
            interval = 1
        }
        
        let nextDate = Calendar.current.date(byAdding: .day, value: interval, to: Date()) ?? Date()
        
        return SM2CalculationResult(
            nextReviewDate: nextDate,
            intervalDays: interval,
            repetitions: reps,
            easinessFactor: ef
        )
    }
}
