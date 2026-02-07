import SwiftUI

struct HeroTimerView: View {
    @EnvironmentObject var viewModel: TimerViewModel
    @EnvironmentObject var soundService: SoundService
    @State private var showPresets = false
    @State private var showCustom = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.neonBackground
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    HStack {
                        Text("CHRONOFLOW")
                            .font(.caption)
                            .tracking(1.8)
                            .foregroundColor(.neonBlue)

                        Spacer()

                        Button {
                            showPresets = true
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)

                    Spacer()

                    VStack(spacing: 14) {
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.12), lineWidth: 10)
                                Circle()
                                    .trim(from: 0, to: min(viewModel.progress, 1))
                                    .stroke(Color.neonBlue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .shadow(color: Color.neonBlue.opacity(0.6), radius: 8)
                                    .rotationEffect(.degrees(-90))

                                GlobeView(intensity: viewModel.progress)
                            }
                            .frame(width: 220, height: 220)

                            VStack(spacing: 6) {
                                Text(viewModel.displayTime)
                                    .font(.system(size: 52, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                    .monospacedDigit()
                                Text(viewModel.isBreakTime ? "BREAK TIME" : "FOCUS TIME")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }

                        HStack(spacing: 12) {
                            Button("Custom Time") {
                                showCustom = true
                            }
                            .buttonStyle(.bordered)
                            .tint(.neonBlue)

                            Button("Presets") {
                                showPresets = true
                            }
                            .buttonStyle(.bordered)
                            .tint(.neonPurple)
                        }

                        Text("Beautiful glass timer")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.7))
                    }

                    Spacer()

                    HStack(spacing: 30) {
                        Button {
                            viewModel.resetTimer()
                        } label: {
                            Image(systemName: "backward.end.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                        }

                        Button {
                            if viewModel.isRunning {
                                viewModel.pauseTimer()
                            } else {
                                viewModel.startTimer()
                            }
                        } label: {
                            Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(18)
                                .background(Color.neonGreen)
                                .clipShape(Circle())
                        }

                        Button {
                            viewModel.resetTimer()
                        } label: {
                            Image(systemName: "forward.end.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
            }
            .sheet(isPresented: $showPresets) {
                PresetSelectionView()
            }
            .sheet(isPresented: $showCustom) {
                CustomTimeView()
            }
            .alert("Almost done", isPresented: $viewModel.showAlmostDoneAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Only 10 seconds left.")
            }
        }
    }
}
