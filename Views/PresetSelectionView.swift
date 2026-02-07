import SwiftUI

struct PresetSelectionView: View {
    @EnvironmentObject var viewModel: TimerViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.neonBackground
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    ForEach(TimerPreset.presets) { preset in
                        Button {
                            viewModel.selectedPreset = preset
                            viewModel.resetTimer()
                        } label: {
                            HStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                    .frame(width: 18, height: 18)
                                    .overlay(
                                        Circle()
                                            .fill(viewModel.selectedPreset.id == preset.id ? Color.neonBlue : .clear)
                                            .frame(width: 10, height: 10)
                                    )

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(preset.name)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    Text("\(preset.focusMinutes) min focus • \(preset.breakMinutes) break")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.caption)
                                }

                                Spacer()
                            }
                            .padding()
                            .glassCard(cornerRadius: 16)
                        }
                    }

                    Text("Choose from proven techniques")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 8)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Select Preset")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") { dismiss() }
                }
            }
        }
    }
}
