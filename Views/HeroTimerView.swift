import SwiftUI

struct HeroTimerView: View {
    @EnvironmentObject var viewModel: TimerViewModel
    @EnvironmentObject var soundService: SoundService
    @State private var showPresets = false
    @State private var showCustom = false
    @State private var isScrubbing = false
    @State private var wasRunningBeforeScrub = false
    @AppStorage("enableAmbientSound") private var enableAmbientSound = false
    @AppStorage("ambientVolume") private var ambientVolume: Double = 0.5
    @AppStorage("ambientSound") private var ambientSound = "grand_project-breath-of-life_60-seconds-320857"

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.neonBackground
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    let ringColor = viewModel.isBreakTime ? Color.neonPurple : Color.neonBlue
                    HStack {
                        Text("CHRONOFLOWFOCUSTIMER")
                            .font(.caption)
                            .tracking(1.8)
                            .foregroundColor(ringColor)

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
                                    .stroke(ringColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .shadow(color: ringColor.opacity(0.6), radius: 8)
                                    .rotationEffect(.degrees(-90))

                                GlobeView(intensity: viewModel.progress, isBreakTime: viewModel.isBreakTime)
                            }
                            .frame(width: 220, height: 220)
                            .contentShape(Circle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        if !isScrubbing {
                                            isScrubbing = true
                                            wasRunningBeforeScrub = viewModel.isRunning
                                            viewModel.pauseTimer()
                                        }

                                        let center = CGPoint(x: 110, y: 110)
                                        let dx = value.location.x - center.x
                                        let dy = value.location.y - center.y
                                        let angle = atan2(dy, dx)
                                        let normalized = (angle + (.pi / 2.0)) / (2.0 * .pi)
                                        let progress = normalized < 0 ? normalized + 1.0 : normalized

                                        viewModel.setProgress(progress)
                                    }
                                    .onEnded { _ in
                                        isScrubbing = false
                                        if wasRunningBeforeScrub {
                                            viewModel.startTimer()
                                        }
                                    }
                            )

                            VStack(spacing: 6) {
                                Text(viewModel.displayTime)
                                    .font(.system(size: 52, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                    .monospacedDigit()
                                Text(viewModel.isBreakTime ? "BREAK TIME" : "FOCUS TIME")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                if viewModel.isBreakTime {
                                    Text("Break remaining \(viewModel.displayTime)")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.55))
                                }
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
            .onChange(of: viewModel.isRunning) { _ in
                syncAmbientPlayback()
            }
            .onChange(of: enableAmbientSound) { _ in
                syncAmbientPlayback()
            }
            .onChange(of: ambientSound) { _ in
                syncAmbientPlayback()
            }
            .onChange(of: ambientVolume) { _ in
                syncAmbientPlayback()
            }
            .onAppear {
                syncAmbientPlayback()
            }
        }
    }

    private func syncAmbientPlayback() {
        guard enableAmbientSound else {
            soundService.stopAmbient()
            return
        }

        if viewModel.isRunning {
            soundService.playAmbient(soundName: ambientSound, volume: Float(ambientVolume))
        } else {
            soundService.stopAmbient()
        }
    }
}
