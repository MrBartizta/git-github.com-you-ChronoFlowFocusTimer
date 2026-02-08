import Foundation

final class SessionStore: ObservableObject {
    static let shared = SessionStore()

    @Published private(set) var sessions: [FocusSession] = []

    private let storageKey = "ChronoFlow.FocusSessions"
    private let calendar = Calendar.current

    private init() {
        load()
    }

    func addSession(minutes: Int, presetName: String, date: Date = Date()) {
        let session = FocusSession(date: date, minutes: minutes, presetName: presetName)
        sessions.insert(session, at: 0)
        save()
    }

    func clearHistory() {
        sessions = []
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    func removeSession(id: UUID) {
        sessions.removeAll { $0.id == id }
        save()
    }

    func removeSessions(at offsets: IndexSet) {
        sessions.remove(atOffsets: offsets)
        save()
    }

    func sessionsForLast7Days() -> [(label: String, minutes: Int)] {
        let today = calendar.startOfDay(for: Date())
        var results: [(String, Int)] = []

        for offset in (0..<7).reversed() {
            guard let day = calendar.date(byAdding: .day, value: -offset, to: today) else { continue }
            let minutes = sessions
                .filter { calendar.isDate($0.date, inSameDayAs: day) }
                .map { $0.minutes }
                .reduce(0, +)
            let label = dayLabel(for: day)
            results.append((label, minutes))
        }
        return results
    }

    func totalMinutesToday() -> Int {
        let today = calendar.startOfDay(for: Date())
        return sessions
            .filter { calendar.isDate($0.date, inSameDayAs: today) }
            .map { $0.minutes }
            .reduce(0, +)
    }

    func recentSessions(limit: Int = 5) -> [FocusSession] {
        Array(sessions.prefix(limit))
    }

    private func dayLabel(for date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale.current
        fmt.dateFormat = "E"
        return fmt.string(from: date)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            sessions = try JSONDecoder().decode([FocusSession].self, from: data)
        } catch {
            sessions = []
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(sessions)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            // Ignore save failures
        }
    }
}
