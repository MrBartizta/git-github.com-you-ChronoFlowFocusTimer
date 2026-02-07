import SwiftUI
import Charts

struct AnalyticsView: View {
    @StateObject private var store = SessionStore.shared
    @State private var showClearConfirm = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.neonBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        HStack {
                            Text("Statistics")
                                .font(.title2)
                                .foregroundColor(.white)

                            Spacer()

                            Button("Clear") {
                                showClearConfirm = true
                            }
                            .foregroundColor(.neonPink)
                        }

                        Text("TODAY: \(formatMinutes(store.totalMinutesToday()))")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))

                        Chart {
                            ForEach(store.sessionsForLast7Days(), id: \.label) { item in
                                BarMark(
                                    x: .value("Day", item.label),
                                    y: .value("Minutes", item.minutes)
                                )
                                .foregroundStyle(Color.neonBlue)
                            }
                        }
                        .frame(height: 180)
                        .padding(.vertical, 6)
                        .glassCard(cornerRadius: 18)

                        Text("Recent Sessions")
                            .font(.headline)
                            .foregroundColor(.white)

                        VStack(spacing: 12) {
                            ForEach(store.recentSessions(), id: \.id) { session in
                                sessionRow(
                                    icon: iconFor(preset: session.presetName),
                                    title: session.presetName,
                                    detail: "\(session.minutes)m",
                                    subtitle: relativeDate(session.date)
                                )
                            }

                            if store.recentSessions().isEmpty {
                                Text("No sessions yet")
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 8)
                            }
                        }

                        Text("Track your focus progress")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 6)
                    }
                    .padding(20)
                }
            }
            .alert("Clear history?", isPresented: $showClearConfirm) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) { store.clearHistory() }
            } message: {
                Text("This will remove all saved sessions.")
            }
        }
    }

    private func sessionRow(icon: String, title: String, detail: String, subtitle: String) -> some View {
        HStack {
            Text(icon)
                .font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(title) • \(detail)")
                    .foregroundColor(.white)
                Text(subtitle)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.caption)
            }
            Spacer()
        }
        .padding()
        .glassCard(cornerRadius: 16)
    }

    private func formatMinutes(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        if h > 0 {
            return "\(h)h \(m)m"
        }
        return "\(m)m"
    }

    private func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    private func iconFor(preset: String) -> String {
        switch preset.lowercased() {
        case "deep work": return "🧠"
        case "flow", "flow time": return "⚡"
        default: return "⏱️"
        }
    }
}
