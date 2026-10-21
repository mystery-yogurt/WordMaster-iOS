import SwiftUI

public struct DeckDetailView: View {
    public let deck: Deck
    @Bindable public var viewModel: TrainerViewModel
    @State private var searchText = ""
    
    public init(deck: Deck, viewModel: TrainerViewModel) {
        self.deck = deck
        self.viewModel = viewModel
    }
    
    private var deckCards: [WordCard] {
        let cards = viewModel.getCardsForDeck(deck.id)
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return cards
        } else {
            return cards.filter {
                $0.word.localizedCaseInsensitiveContains(searchText) ||
                $0.translation.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    public var body: some View {
        List {
            Section {
                HStack(spacing: 14) {
                    Image(systemName: deck.icon)
                        .font(.largeTitle)
                        .foregroundStyle(Color.blue)
                        .frame(width: 56, height: 56)
                        .background(Color.blue.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(deck.title)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("Всего карточек: \(viewModel.getCardsForDeck(deck.id).count)")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)
                    }
                }
                .padding(.vertical, 6)
            }
            
            Section("Слова в словаре (\(deckCards.count))") {
                if deckCards.isEmpty {
                    ContentUnavailableView(
                        "Словарь пуст",
                        systemImage: "tray",
                        description: Text("Используйте захват камерой (OCR) или поиск по офлайн-словарю для добавления карточек.")
                    )
                } else {
                    ForEach(deckCards) { card in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(card.word)
                                    .font(.headline)
                                Text(card.transcription)
                                    .font(.caption)
                                    .italic()
                                    .foregroundStyle(Color.secondary)
                                Spacer()
                                
                                Text("Ур. \(card.memoryLevel)/5")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(card.isDueForReview ? Color.orange.opacity(0.15) : Color.green.opacity(0.15))
                                    .foregroundStyle(card.isDueForReview ? Color.orange : Color.green)
                                    .clipShape(Capsule())
                            }
                            
                            Text(card.translation)
                                .font(.subheadline)
                                .foregroundStyle(Color.primary)
                            
                            Text("“\(card.exampleSentence)”")
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                                .italic()
                            
                            HStack {
                                Text("Интервал: \(card.intervalDays) дн.")
                                Text("•")
                                Text("EF: \(String(format: "%.2f", card.easinessFactor))")
                                Spacer()
                                if card.isDueForReview {
                                    Text("Готово к повторению")
                                        .font(.caption2)
                                        .foregroundStyle(Color.orange)
                                }
                            }
                            .font(.caption2)
                            .foregroundStyle(Color.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let cardToRemove = deckCards[index]
                            viewModel.deleteCard(id: cardToRemove.id)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Поиск слов в этом словаре")
        .navigationTitle(deck.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
