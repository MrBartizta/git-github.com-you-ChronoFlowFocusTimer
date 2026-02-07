import SwiftUI

struct SettingsView: View {
    @AppStorage("enableHaptics") private var enableHaptics = true
    @AppStorage("enableNotifications") private var enableNotifications = true
    @State private var showingAbout = false

    var body: some View {
        NavigationView {
            List {
                Section("Preferences") {
                    Toggle("Enable Haptic Feedback", isOn: $enableHaptics)
                    Toggle("Daily Reminders", isOn: $enableNotifications)

                    NavigationLink {
                        SoundSettingsView()
                    } label: {
                        Label("Sound Settings", systemImage: "speaker.wave.2")
                    }
                }
                .listRowBackground(Color.white.opacity(0.1))

                Section("About") {
                    Button {
                        showingAbout.toggle()
                    } label: {
                        Label("About Zenith Focus", systemImage: "info.circle")
                    }

                    Link(destination: URL(string: "https://yourwebsite.com")!) {
                        Label("Website", systemImage: "globe")
                    }

                    Link(destination: URL(string: "mailto:support@yourwebsite.com")!) {
                        Label("Contact Support", systemImage: "envelope")
                    }
                }
                .listRowBackground(Color.white.opacity(0.1))

                Section {
                    VStack(spacing: 10) {
                        Text("Zenith Focus v1.0")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("Made with ❤️ for focused minds")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(
                LinearGradient(
                    colors: [Color.black, Color(hex: "0A0A2A")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Settings")
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct SoundSettingsView: View {
    @EnvironmentObject var soundService: SoundService

    var body: some View {
        NavigationView {
            List {
                Section("Volume") {
                    HStack {
                        Image(systemName: "speaker.fill")
                        Slider(value: $soundService.volume, in: 0...1)
                        Image(systemName: "speaker.wave.3.fill")
                    }
                }
                .listRowBackground(Color.white.opacity(0.1))
            }
            .navigationTitle("Sound Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
}

struct AboutView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "timer")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding()
                    .glassBackground()
                    .padding(.top, 40)

                Text("Zenith Focus")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("v1.0")
                    .foregroundColor(.secondary)

                Text("A futuristic focus timer designed for deep work and productivity. Simple, beautiful, and effective.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.vertical)

                Spacer()

                Text("Thank you for your purchase!")
                    .font(.headline)
                    .padding()
                    .glassBackground()

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.black, Color(hex: "0A0A2A")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
