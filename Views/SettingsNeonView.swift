import SwiftUI

struct SettingsNeonView: View {
    @AppStorage("enableHaptics") private var enableHaptics = true
    @AppStorage("enableNotifications") private var enableNotifications = true
    @AppStorage("enableAmbientSound") private var enableAmbientSound = false
    @AppStorage("ambientVolume") private var ambientVolume: Double = 0.5
    @AppStorage("ambientSound") private var ambientSound = "grand_project-breath-of-life_60-seconds-320857"
    @EnvironmentObject var soundService: SoundService

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
                    ToggleRow(title: "Ambient Sound", isOn: $enableAmbientSound)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ambient Volume")
                            .foregroundColor(.white)
                        Slider(value: $ambientVolume, in: 0...1, step: 0.05)
                            .tint(.neonBlue)
                    }
                    .padding()
                    .glassCard(cornerRadius: 16)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Soundscape")
                            .foregroundColor(.white)
                        Picker("Soundscape", selection: $ambientSound) {
                            ForEach(SoundService.availableAmbientSounds, id: \.self) { sound in
                                Text(displayName(for: sound))
                                    .tag(sound)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
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
            .onChange(of: enableAmbientSound) { _ in
                syncAmbientAudio()
            }
            .onChange(of: ambientVolume) { _ in
                syncAmbientAudio()
            }
            .onChange(of: ambientSound) { _ in
                syncAmbientAudio()
            }
            .onAppear {
                syncAmbientAudio()
            }
        }
    }

    private func syncAmbientAudio() {
        if enableAmbientSound {
            soundService.playAmbient(soundName: ambientSound, volume: Float(ambientVolume))
        } else {
            soundService.stopAmbient()
        }
    }

    private func displayName(for sound: String) -> String {
        if sound == "grand_project-breath-of-life_60-seconds-320857" {
            return "Breath of Life"
        }
        return sound.replacingOccurrences(of: "_", with: " ").capitalized
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
