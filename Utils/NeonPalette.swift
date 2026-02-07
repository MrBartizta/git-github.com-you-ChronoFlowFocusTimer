import SwiftUI

extension Color {
    static let neonBlue = Color(hex: "00E5FF")
    static let neonPink = Color(hex: "FF2A6D")
    static let neonGreen = Color(hex: "00FF9D")
    static let neonPurple = Color(hex: "9D4EDD")
    static let neonBackground = Color(hex: "0B0D17")
}

extension LinearGradient {
    static let neonBackground = LinearGradient(
        colors: [Color(hex: "0B0D17"), Color(hex: "10162A"), Color(hex: "0B0D17")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
