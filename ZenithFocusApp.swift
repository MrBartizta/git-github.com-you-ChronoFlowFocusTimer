import SwiftUI

@main
struct ZenithFocusApp: App {
    @StateObject private var timerViewModel = TimerViewModel()
    @StateObject private var soundService = SoundService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerViewModel)
                .environmentObject(soundService)
                .preferredColorScheme(.dark)
        }
    }
}
