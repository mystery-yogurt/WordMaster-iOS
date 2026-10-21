import Foundation
import UserNotifications

public final class NotificationService {
    public static let shared = NotificationService()
    
    private init() {
        requestAuthorization()
    }
    
    public func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }
    
    /// Агрегирует ближайшие повторения, сбрасывает старые и ставит новый триггер
    public func rescheduleNearestReview(cards: [WordCard]) {
        let center = UNUserNotificationCenter.current()
        
        // 1. Очищаем старые запланированные уведомления очереди
        center.removeAllPendingNotificationRequests()
        
        // 2. Находим ближайшую дату повторения
        let dueCards = cards.sorted { $0.nextReviewDate < $1.nextReviewDate }
        guard let nextCard = dueCards.first else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "🧠 Время повторения слов (SM-2)!"
        content.body = "Пора повторить слово «\(nextCard.word)» и другие карточки в очереди."
        content.sound = .default
        
        // Для симулятора ставим триггер на 10 секунд
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "SM2_Review_Trigger", content: content, trigger: trigger)
        
        center.add(request) { error in
            if error == nil {
                print("✓ Запланировано новое push-напоминание на ближайшую сессию")
            }
        }
    }
}
