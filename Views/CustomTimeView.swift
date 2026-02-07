import SwiftUI

struct CustomTimeView: View {
    @EnvironmentObject var viewModel: TimerViewModel
    @Environment(\.dismiss) var dismiss
    @State private var focusMinutes: Int = 25
    @State private var breakMinutes: Int = 5

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.neonBackground
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Focus Minutes")
                            .foregroundColor(.white)
                        Stepper(value: $focusMinutes, in: 5...180, step: 5) {
                            Text("\(focusMinutes) min")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .glassCard(cornerRadius: 16)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Break Minutes")
                            .foregroundColor(.white)
                        Stepper(value: $breakMinutes, in: 0...60, step: 5) {
                            Text("\(breakMinutes) min")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .glassCard(cornerRadius: 16)

                    Button("Apply") {
                        let custom = TimerPreset(
                            name: "Custom",
                            focusMinutes: focusMinutes,
                            breakMinutes: breakMinutes,
                            colorHex: "00E5FF",
                            iconName: "timer"
                        )
                        viewModel.selectedPreset = custom
                        viewModel.resetTimer()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.neonGreen)

                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Custom Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") { dismiss() }
                }
            }
            .onAppear {
                focusMinutes = viewModel.selectedPreset.focusMinutes
                breakMinutes = viewModel.selectedPreset.breakMinutes
            }
        }
    }
}
