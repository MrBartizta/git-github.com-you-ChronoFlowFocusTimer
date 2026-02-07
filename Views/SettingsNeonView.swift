import SwiftUI

struct SettingsNeonView: View {
    @AppStorage("enableHaptics") private var enableHaptics = true
    @AppStorage("enableNotifications") private var enableNotifications = true

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.neonBackground
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    VStack(spacing: 10) {
                        Image("AppLogo")
                            .resizable()
                            .frame(width: 72, height: 72)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.neonBlue.opacity(0.6), radius: 12)

                        Text("ChronoFlowFocusTimer")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 8)

                    ToggleRow(title: "Haptic Feedback", isOn: $enableHaptics)
                    ToggleRow(title: "Daily Reminders", isOn: $enableNotifications)

                    VStack(alignment: .leading, spacing: 10) {
                        Link("Privacy Policy", destination: AppInfo.privacyURL)
                        Link("Support", destination: AppInfo.supportURL)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .glassCard(cornerRadius: 16)

                    Text("Paid app. No subscriptions.")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 6)

                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.neonBlue)
        }
        .padding()
        .glassCard(cornerRadius: 16)
    }
}
