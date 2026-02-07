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

                        Text("ChronoFlow")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 8)

                    ToggleRow(title: "Haptic Feedback", isOn: $enableHaptics)
                    ToggleRow(title: "Daily Reminders", isOn: $enableNotifications)

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("One-Time Purchase")
                                .foregroundColor(.white)
                            Text("Own forever • $3.99")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.caption)
                        }
                        Spacer()
                        Image(systemName: "globe")
                            .foregroundColor(.neonBlue)
                    }
                    .padding()
                    .glassCard(cornerRadius: 16)

                    VStack(alignment: .leading, spacing: 10) {
                        Link("Privacy Policy", destination: AppInfo.privacyURL)
                        Link("Support", destination: AppInfo.supportURL)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .glassCard(cornerRadius: 16)

                    Text("No subscriptions. Own forever.")
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
