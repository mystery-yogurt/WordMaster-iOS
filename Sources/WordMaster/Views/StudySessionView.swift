import SwiftUI

public struct StudySessionView: View {
    @Bindable public var viewModel: TrainerViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentIndex = 0
    @State private var sessionFinished = false
    
    public init(viewModel: TrainerViewModel) {
        self.viewModel = viewModel
    }
    
    private var sessionCards: [WordCard] {
        viewModel.dueCards
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
                if sessionCards.isEmpty || sessionFinished {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(Color.green)
                        
                        Text("Сессия завершена!")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Все карточки на сегодня обработаны алгоритмом SM-2. Следующее повторение запланировано в очереди.")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        
                        Button("Вернуться") {
                            dismiss()
                        }
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .clipShape(Capsule())
                    }
                    .padding()
                } else if currentIndex < sessionCards.count {
                    let card = sessionCards[currentIndex]
                    
                    VStack(spacing: 16) {
                        HStack {
                            Text("Карточка \(currentIndex + 1) из \(sessionCards.count)")
                                .font(.subheadline)
                                .foregroundStyle(Color.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        FlashcardView(card: card) { quality in
                            viewModel.processReviewAnswer(cardId: card.id, quality: quality)
                            if currentIndex + 1 < sessionCards.count {
                                currentIndex += 1
                            } else {
                                sessionFinished = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("Сессия повторений")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
}
