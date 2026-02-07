import Foundation

struct FocusSession: Identifiable, Codable {
    let id: UUID
    let date: Date
    let minutes: Int
    let presetName: String

    init(id: UUID = UUID(), date: Date = Date(), minutes: Int, presetName: String) {
        self.id = id
        self.date = date
        self.minutes = minutes
        self.presetName = presetName
    }
}
