import SwiftUI

public struct FlashcardView: View {
    public let card: WordCard
    public let onAnswer: (Int) -> Void
    
    @State private var isFlipped = false
    @State private var rotationDegrees = 0.0
    
    public init(card: WordCard, onAnswer: @escaping (Int) -> Void) {
        self.card = card
        self.onAnswer = onAnswer
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // Лицевая сторона (Слово, транскрипция, уровень)
                VStack(spacing: 16) {
                    HStack {
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "brain.head.profile")
                            Text("Уровень: \(card.memoryLevel)/5")
                        }
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.15))
                        .foregroundStyle(Color.blue)
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    Text(card.word)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(Color.primary)
                    
                    Text(card.transcription)
                        .font(.title3)
                        .italic()
                        .foregroundStyle(Color.secondary)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("Нажмите для перевода")
                    }
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .frame(height: 320)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: Color.black.opacity(0.08), radius: 10, y: 4)
                .opacity(isFlipped ? 0 : 1)
                
                // Оборотная сторона (Перевод, пример, кнопки SM-2)
                VStack(spacing: 14) {
                    Text("ПЕРЕВОД")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.secondary)
                    
                    Text(card.translation)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.green)
                        .multilineTextAlignment(.center)
                    
                    Divider()
                        .padding(.vertical, 4)
                    
                    Text("Пример использования:")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                    
                    Text("“\(card.exampleSentence)”")
                        .font(.subheadline)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Text("Оцените легкость ответа (SM-2):")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.secondary)
                    
                    // Кнопки оценки по алгоритму SM-2 (0...5)
                    HStack(spacing: 8) {
                        Button("Снова (1)") { onAnswer(1) }
                            .font(.caption2)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color.red.opacity(0.15))
                            .foregroundStyle(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Button("Трудно (3)") { onAnswer(3) }
                            .font(.caption2)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color.orange.opacity(0.15))
                            .foregroundStyle(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Button("Хорошо (4)") { onAnswer(4) }
                            .font(.caption2)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color.blue.opacity(0.15))
                            .foregroundStyle(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Button("Легко (5)") { onAnswer(5) }
                            .font(.caption2)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color.green.opacity(0.15))
                            .foregroundStyle(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .frame(height: 320)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: Color.black.opacity(0.08), radius: 10, y: 4)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 1 : 0)
            }
            .rotation3DEffect(.degrees(rotationDegrees), axis: (x: 0, y: 1, z: 0))
            .onTapGesture {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    rotationDegrees += 180
                    isFlipped.toggle()
                }
            }
        }
        .padding(.horizontal)
    }
}
