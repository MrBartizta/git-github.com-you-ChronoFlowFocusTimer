import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @State private var showWelcome = true
    @State private var selectedTab: Tab = .timer

    private enum Tab {
        case timer
        case stats
        case settings
        case reset
    }

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HeroTimerView()
                    .tabItem { Label("Timer", systemImage: "timer") }
                    .tag(Tab.timer)

                AnalyticsView()
                    .tabItem { Label("Stats", systemImage: "chart.bar") }
                    .tag(Tab.stats)

                SettingsNeonView()
                    .tabItem { Label("Settings", systemImage: "gear") }
                    .tag(Tab.settings)

                Color.clear
                    .tabItem { Label("Reset", systemImage: "arrow.counterclockwise") }
                    .tag(Tab.reset)
            }
            .tint(.neonBlue)
            .onChange(of: selectedTab) { newTab in
                guard newTab == .reset else { return }
                timerViewModel.resetTimer()
                selectedTab = .timer
            }

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
