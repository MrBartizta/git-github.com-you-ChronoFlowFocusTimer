import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var viewModel: TimerViewModel
    private let sessionIcons = ["timer", "brain.head.profile", "bolt.fill"]
    private let sessionNames = ["Pomodoro", "Deep Work", "Flow Time"]
    private let sessionRecency = ["Today", "Yesterday", "2 days ago"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    weeklyChartSection
                    quickStatsSection
                    recentSessionsSection
                }
                .padding(.vertical)
            }
            .background(
                LinearGradient(
                    colors: [Color.black, Color(hex: "0A0A2A")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
    }

    private var weeklyChartSection: some View {
        VStack(alignment: .leading) {
            Text("This Week")
                .font(.headline)

            Chart {
                ForEach(0..<7, id: \.self) { day in
                    BarMark(
                        x: .value("Day", "Day \(day + 1)"),
                        y: .value("Minutes", Int.random(in: 0...120))
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                }
            }
            .frame(height: 200)
            .padding()
            .glassBackground()
        }
        .padding()
    }

    private var quickStatsSection: some View {
        HStack(spacing: 15) {
            StatCard(
                title: "Today",
                value: "45 min",
                icon: "sun.max.fill",
                color: .orange
            )

            StatCard(
                title: "This Week",
                value: "6h 20m",
                icon: "calendar",
                color: .blue
            )
        }
        .padding(.horizontal)
    }

    private var recentSessionsSection: some View {
        VStack(alignment: .leading) {
            Text("Recent Sessions")
                .font(.headline)
                .padding(.horizontal)

            ForEach(0..<5, id: \.self) { _ in
                let icon = sessionIcons.randomElement() ?? "timer"
                let name = sessionNames.randomElement() ?? "Pomodoro"
                let recency = sessionRecency.randomElement() ?? "Today"
                let minutes = Int.random(in: 25...90)
                let hour = Int.random(in: 1...5)
                let minute = Int.random(in: 0...59)
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                        .frame(width: 30)

                    VStack(alignment: .leading) {
                        Text(name)
                            .fontWeight(.medium)
                        Text("\(minutes) min • \(recency)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Text("\(hour):\(String(format: "%02d", minute))")
                        .font(.callout.monospacedDigit())
                }
                .padding()
                .glassBackground()
                .padding(.horizontal)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(height: 30)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .glassBackground()
    }
}
