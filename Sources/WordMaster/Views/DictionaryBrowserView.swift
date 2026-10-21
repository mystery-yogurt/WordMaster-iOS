import SwiftUI

public struct DictionaryBrowserView: View {
    @Bindable public var viewModel: TrainerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchQuery = ""
    @State private var addedWordId: String? = nil
    
    public init(viewModel: TrainerViewModel) {
        self.viewModel = viewModel
    }
    
    private var filteredVocabulary: [OfflineDictionaryEntry] {
        let all = OfflineDictionaryService.shared.vocabulary
        if searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return all
        } else {
            return all.filter {
                $0.word.localizedCaseInsensitiveContains(searchQuery) ||
                $0.translation.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
    private var sectionTitle: String {
        if searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Слова (1000)"
        } else {
            return "Слова (\(filteredVocabulary.count))"
        }
    }
    
    public var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("База содержит **\(OfflineDictionaryService.shared.vocabulary.count)** офлайн-записей популярной лексики с транскрипциями и примерами (Вспомогательное NoSQL/Realm-хранилище).")
                        .font(.footnote)
                        .foregroundStyle(Color.secondary)
                }
                
                Section(sectionTitle) {
                    ForEach(filteredVocabulary) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 8) {
                                    Text(item.word)
                                        .font(.headline)
                                    Text(item.transcription)
                                        .font(.caption)
                                        .italic()
                                        .foregroundStyle(Color.secondary)
                                }
                                Text(item.translation)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.blue)
                                Text("“\(item.example)”")
                                    .font(.caption)
                                    .italic()
                                    .foregroundStyle(Color.secondary)
                            }
                            
                            Spacer()
                            
                            Button {
                                viewModel.handleScannedWord(item.word)
                                addedWordId = item.id
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    addedWordId = nil
                                }
                            } label: {
                                if addedWordId == item.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.green)
                                } else {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(Color.blue)
                                }
                            }
                            .buttonStyle(.borderless)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .searchable(text: $searchQuery, prompt: "Поиск из 1000 слов...")
            .navigationTitle("Офлайн-словарь (1000 слов)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }
}
