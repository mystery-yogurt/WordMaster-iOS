import SwiftUI
import Charts

public struct WeeklyChartView: View {
    public let stats: [WeeklyStat]
    
    public init(stats: [WeeklyStat]) {
        self.stats = stats
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(Color.blue)
                Text("Изучено за неделю (Swift Charts)")
                    .font(.headline)
            }
            
            Chart(stats) { stat in
                BarMark(
                    x: .value("День", stat.day),
                    y: .value("Слов", stat.wordsLearned)
                )
                .foregroundStyle(Color.blue.gradient)
                .cornerRadius(6)
            }
            .frame(height: 140)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
