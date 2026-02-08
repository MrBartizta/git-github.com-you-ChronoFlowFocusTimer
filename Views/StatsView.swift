import SwiftUI
import Charts

struct StatsView: View {
    @ObservedObject private var sessionStore = SessionStore.shared
    private let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
    @State private var showDeleteConfirm = false
    @State private var pendingDelete: FocusSession?

    var body: some View {
        NavigationView {
            List {
                weeklyChartSection
                quickStatsSection
                recentSessionsSection
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
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
            .confirmationDialog(
                "Delete Session?",
                isPresented: $showDeleteConfirm,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    if let session = pendingDelete {
                        sessionStore.removeSession(id: session.id)
                    }
                    pendingDelete = nil
                }
                Button("Cancel", role: .cancel) {
                    pendingDelete = nil
                }
            } message: {
                Text("This will remove the selected session.")
            }
        }
    }

    private var weeklyChartSection: some View {
        VStack(alignment: .leading) {
            Text("This Week")
                .font(.headline)

            Chart {
                ForEach(sessionStore.sessionsForLast7Days(), id: \.label) { day in
                    BarMark(
                        x: .value("Day", day.label),
                        y: .value("Minutes", day.minutes)
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
        .listRowBackground(Color.clear)
    }

    private var quickStatsSection: some View {
        let todayMinutes = sessionStore.totalMinutesToday()
        let weekMinutes = sessionStore.sessionsForLast7Days().map(\.minutes).reduce(0, +)
        return HStack(spacing: 15) {
            StatCard(
                title: "Today",
                value: "\(todayMinutes) min",
                icon: "sun.max.fill",
                color: .orange
            )

            StatCard(
                title: "This Week",
                value: formattedMinutes(weekMinutes),
                icon: "calendar",
                color: .blue
            )
        }
        .padding(.horizontal)
        .listRowBackground(Color.clear)
    }

    private var recentSessionsSection: some View {
        Section {
            ForEach(sessionStore.recentSessions(limit: 10)) { session in
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(.blue)
                        .frame(width: 30)

                    VStack(alignment: .leading) {
                        Text(session.presetName)
                            .fontWeight(.medium)
                        Text("\(session.minutes) min • \(relativeDate(for: session.date))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Text(timeString(for: session.date))
                        .font(.callout.monospacedDigit())

                }
                .padding()
                .glassBackground()
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        } header: {
            Text("Recent Sessions")
                .font(.headline)
                .foregroundColor(.white)
        }
    }

    private func formattedMinutes(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min"
        }
        let hours = minutes / 60
        let remainder = minutes % 60
        return remainder == 0 ? "\(hours)h" : "\(hours)h \(remainder)m"
    }

    private func timeString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func relativeDate(for date: Date) -> String {
        relativeFormatter.localizedString(for: date, relativeTo: Date())
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
