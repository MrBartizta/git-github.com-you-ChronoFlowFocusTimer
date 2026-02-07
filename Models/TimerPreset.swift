import Foundation
import SwiftUI

struct TimerPreset: Identifiable, Codable {
    let id = UUID()
    let name: String
    let focusMinutes: Int
    let breakMinutes: Int
    let colorHex: String
    let iconName: String

    private enum CodingKeys: String, CodingKey {
        case name, focusMinutes, breakMinutes, colorHex, iconName
    }

    static let presets = [
        TimerPreset(
            name: "Pomodoro",
            focusMinutes: 25,
            breakMinutes: 5,
            colorHex: "FF6B6B",
            iconName: "timer"
        ),
        TimerPreset(
            name: "Flow",
            focusMinutes: 52,
            breakMinutes: 17,
            colorHex: "4ECDC4",
            iconName: "bolt.fill"
        ),
        TimerPreset(
            name: "Deep Work",
            focusMinutes: 90,
            breakMinutes: 20,
            colorHex: "9B5DE5",
            iconName: "brain.head.profile"
        )
    ]
}
