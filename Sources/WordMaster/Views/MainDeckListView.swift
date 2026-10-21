import SwiftUI

public struct MainDeckListView: View {
    @State private var viewModel = TrainerViewModel()
    @State private var showingSession = false
    @State private var showingScanner = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. График статистики Swift Charts (Вариант 13)
                    WeeklyChartView(stats: viewModel.weeklyStats)
                        .padding(.horizontal)
                    
                    // 2. Блок запуска сессии повторений
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Очередь повторений")
                                .font(.headline)
                            Text("Слов к повторению сегодня: \(viewModel.dueCards.count)")
                                .font(.subheadline)
                                .foregroundStyle(Color.secondary)
                        }
                        Spacer()
                        Button {
                            showingSession = true
                        } label: {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Начать")
                            }
                            .font(.headline)
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(viewModel.dueCards.isEmpty ? Color.gray : Color.green)
                            .clipShape(Capsule())
                        }
                        .disabled(viewModel.dueCards.isEmpty)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // 3. Список личных словарей пользователя
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Мои словари")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(viewModel.decks) { deck in
                            let count = viewModel.getCardsForDeck(deck.id).count
                            HStack(spacing: 14) {
                                Image(systemName: deck.icon)
                                    .font(.title2)
                                    .foregroundStyle(Color.blue)
                                    .frame(width: 44, height: 44)
                                    .background(Color.blue.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(deck.title)
                                        .font(.headline)
                                    Text("\(count) слов в наборе")
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                            }
                            .padding(14)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("WordMaster")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingScanner = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "camera.viewfinder")
                            Text("Захват")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                }
            }
            .sheet(isPresented: $showingSession) {
                StudySessionView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingScanner) {
                ScannerView(viewModel: viewModel)
            }
        }
    }
}
