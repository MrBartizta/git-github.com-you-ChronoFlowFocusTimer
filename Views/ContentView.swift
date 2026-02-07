import SwiftUI

struct ContentView: View {
    @State private var showWelcome = true

    var body: some View {
        ZStack {
            TabView {
                HeroTimerView()
                    .tabItem { Label("Timer", systemImage: "timer") }

                AnalyticsView()
                    .tabItem { Label("Stats", systemImage: "chart.bar") }

                SettingsNeonView()
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
            .tint(.neonBlue)

            if showWelcome {
                WelcomeView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showWelcome = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TimerViewModel())
        .environmentObject(SoundService())
}
