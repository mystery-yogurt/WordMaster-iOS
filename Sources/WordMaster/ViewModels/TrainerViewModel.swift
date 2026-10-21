import Foundation
import Observation
import Combine

@Observable
public final class TrainerViewModel {
    public var decks: [Deck] = []
    public var cards: [WordCard] = []
    public var selectedDeck: Deck? = nil
    
    // Статистика изученных слов за неделю (для Swift Charts)
    public var weeklyStats: [WeeklyStat] = [
        WeeklyStat(day: "Пн", wordsLearned: 12),
        WeeklyStat(day: "Вт", wordsLearned: 18),
        WeeklyStat(day: "Ср", wordsLearned: 15),
        WeeklyStat(day: "Чт", wordsLearned: 24),
        WeeklyStat(day: "Пт", wordsLearned: 20),
        WeeklyStat(day: "Сб", wordsLearned: 32),
        WeeklyStat(day: "Вс", wordsLearned: 28)
    ]
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        setupCombineBrokerSubscription()
        loadData()
    }
    
    // Подписка на внутренний брокер Combine
    private func setupCombineBrokerSubscription() {
        WordEventBroker.shared.scannedWordSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] word in
                self?.handleScannedWord(word)
            }
            .store(in: &cancellables)
    }
    
    // Автоматическое заполнение карточки при совпадении с офлайн-словарем
    public func handleScannedWord(_ word: String) {
        guard let deck = selectedDeck ?? decks.first else { return }
        
        if let entry = OfflineDictionaryService.shared.lookup(word: word) {
            // Проверяем, чтобы не дублировать существующее слово в колоде
            if !cards.contains(where: { $0.deckId == deck.id && $0.word.lowercased() == entry.word.lowercased() }) {
                let newCard = WordCard(
                    word: entry.word,
                    transcription: entry.transcription,
                    translation: entry.translation,
                    exampleSentence: entry.example,
                    deckId: deck.id,
                    repetitions: 0,
                    intervalDays: 1,
                    easinessFactor: 2.5,
                    nextReviewDate: Date()
                )
                cards.insert(newCard, at: 0)
                saveData()
                NotificationService.shared.rescheduleNearestReview(cards: cards)
            }
        }
    }
    
    // Карточки, готовые к повторению прямо сейчас
    public var dueCards: [WordCard] {
        cards.filter { $0.isDueForReview }
    }
    
    // Обработка ответа пользователя по алгоритму SM-2
    public func processReviewAnswer(cardId: UUID, quality: Int) {
        guard let index = cards.firstIndex(where: { $0.id == cardId }) else { return }
        
        let result = SM2Algorithm.calculate(card: cards[index], quality: quality)
        
        cards[index].nextReviewDate = result.nextReviewDate
        cards[index].intervalDays = result.intervalDays
        cards[index].repetitions = result.repetitions
        cards[index].easinessFactor = result.easinessFactor
        
        saveData()
        NotificationService.shared.rescheduleNearestReview(cards: cards)
    }
    
    public func deleteCard(id: UUID) {
        cards.removeAll { $0.id == id }
        saveData()
        NotificationService.shared.rescheduleNearestReview(cards: cards)
    }
    
    public func getCardsForDeck(_ deckId: UUID) -> [WordCard] {
        cards.filter { $0.deckId == deckId }
    }
    
    private func saveData() {
        LocalStorageService.shared.saveDecks(decks)
        LocalStorageService.shared.saveCards(cards)
    }
    
    private func loadData() {
        if let loadedDecks = LocalStorageService.shared.loadDecks(),
           let loadedCards = LocalStorageService.shared.loadCards(),
           !loadedDecks.isEmpty {
            self.decks = loadedDecks
            self.cards = loadedCards
            self.selectedDeck = loadedDecks.first
        } else {
            initDefaultData()
            saveData()
        }
    }
    
    private func initDefaultData() {
        let deck1 = Deck(title: "IT & Технологии", icon: "laptopcomputer", colorHex: "007AFF")
        let deck2 = Deck(title: "IELTS & Академический", icon: "graduationcap.fill", colorHex: "34C759")
        let deck3 = Deck(title: "Повседневный английский", icon: "bubble.left.and.bubble.right.fill", colorHex: "FF9500")
        
        self.decks = [deck1, deck2, deck3]
        self.selectedDeck = deck1
        
        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let futureDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
        
        self.cards = [
            WordCard(
                word: "ubiquitous",
                transcription: "[juːˈbɪkwɪtəs]",
                translation: "вездесущий, повсеместный",
                exampleSentence: "Smartphones have become ubiquitous in modern daily life.",
                deckId: deck1.id,
                repetitions: 2,
                intervalDays: 1,
                easinessFactor: 2.5,
                nextReviewDate: pastDate
            ),
            WordCard(
                word: "resilience",
                transcription: "[rɪˈzɪliəns]",
                translation: "устойчивость, стойкость",
                exampleSentence: "The team showed great resilience during the crisis.",
                deckId: deck2.id,
                repetitions: 1,
                intervalDays: 1,
                easinessFactor: 2.5,
                nextReviewDate: pastDate
            ),
            WordCard(
                word: "ephemeral",
                transcription: "[ɪˈfemərəl]",
                translation: "мимолетный, эфемерный",
                exampleSentence: "Fame in the internet age can be quite ephemeral.",
                deckId: deck2.id,
                repetitions: 3,
                intervalDays: 6,
                easinessFactor: 2.6,
                nextReviewDate: futureDate
            )
        ]
    }
}
