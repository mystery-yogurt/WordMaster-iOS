import SwiftUI

public struct ScannerView: View {
    @Bindable public var viewModel: TrainerViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let sampleWords = ["ubiquitous", "resilience", "ephemeral", "leverage", "diligent", "meticulous"]
    @State private var selectedWord = "ubiquitous"
    @State private var isCapturing = false
    @State private var capturedSuccess = false
    
    public init(viewModel: TrainerViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Видоискатель камеры (Mock OCR)
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.88))
                            .frame(height: 220)
                        
                        VStack(spacing: 12) {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 60))
                                .foregroundStyle(isCapturing ? Color.yellow : (capturedSuccess ? Color.green : Color.white))
                            
                            Text(isCapturing ? "Оптический захват слова (OCR)..." : (capturedSuccess ? "✓ Слово захвачено и отправлено в Combine!" : "Наведите рамку на незнакомое слово в тексте"))
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Выбор слова из книжного текста
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Текст книги / этикетки в фокусе камеры:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.secondary)
                            .padding(.horizontal)
                        
                        ForEach(sampleWords, id: \.self) { word in
                            HStack {
                                Text("... text with \(word) in context ...")
                                    .font(.system(.subheadline, design: .monospaced))
                                Spacer()
                                if selectedWord == word {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.green)
                                }
                            }
                            .padding(12)
                            .background(selectedWord == word ? Color.blue.opacity(0.12) : Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedWord == word ? Color.blue : Color.clear, lineWidth: 1.5)
                            )
                            .padding(.horizontal)
                            .onTapGesture {
                                selectedWord = word
                                capturedSuccess = false
                            }
                        }
                    }
                    
                    // Кнопка захвата и отправки в брокер Combine
                    Button {
                        isCapturing = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            // 1. Отправка во внутренний брокер Combine
                            WordEventBroker.shared.sendScannedWord(selectedWord)
                            isCapturing = false
                            capturedSuccess = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Захватить слово с камеры")
                        }
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal)
                    .disabled(isCapturing)
                    
                    if capturedSuccess {
                        VStack(spacing: 8) {
                            Text("Слово «\(selectedWord)» автоматически найдено во встроенном словаре, переведено и добавлено в базу данных!")
                                .font(.footnote)
                                .foregroundStyle(Color.green)
                                .multilineTextAlignment(.center)
                            
                            Button("Готово") { dismiss() }
                                .font(.headline)
                                .padding(.top, 4)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Камера (Оптический захват)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
            }
        }
    }
}
