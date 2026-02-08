import Foundation
import SwiftUI
import UIKit

class TimerViewModel: ObservableObject {
    @Published var selectedPreset: TimerPreset = TimerPreset.presets[0]
    @Published var timeRemaining: TimeInterval = 25 * 60
    @Published var isRunning = false
    @Published var progress: Double = 0
    @Published var isBreakTime = false
    @Published var showAlmostDoneAlert = false

    private var timer: Timer?
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private var totalTime: TimeInterval {
        TimeInterval((isBreakTime ? selectedPreset.breakMinutes : selectedPreset.focusMinutes) * 60)
    }

    var totalTimeSeconds: TimeInterval {
        totalTime
    }

    var displayTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    init() {
        resetTimer()
    }

    func startTimer() {
        guard !isRunning else { return }

        isRunning = true
        hapticGenerator.prepare()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }

    func resetTimer(keepRunning: Bool = false) {
        isRunning = false
        timer?.invalidate()
        isBreakTime = false
        timeRemaining = totalTime
        progress = 0
        showAlmostDoneAlert = false
        if keepRunning {
            startTimer()
        }
    }

    func skipBreak() {
        isBreakTime = false
        resetTimer()
    }

    func setProgress(_ value: Double) {
        let clamped = max(0.0, min(1.0, value))
        progress = clamped
        timeRemaining = max(0, totalTime * (1.0 - clamped))
    }

    private func tick() {
        guard timeRemaining > 0 else { return }

        timeRemaining -= 1
        triggerCountdownHapticsIfNeeded()
        if timeRemaining <= 0 {
            // Seamless transition between focus and break without stopping the timer.
            if !isBreakTime {
                SessionStore.shared.addSession(minutes: selectedPreset.focusMinutes, presetName: selectedPreset.name)
            }
            isBreakTime.toggle()
            timeRemaining = totalTime
            progress = 0
            showAlmostDoneAlert = false
            return
        }

        if timeRemaining == 10 {
            showAlmostDoneAlert = true
        }

        progress = 1.0 - (timeRemaining / totalTime)
    }

    private func triggerCountdownHapticsIfNeeded() {
        let hapticsEnabled = UserDefaults.standard.object(forKey: "enableHaptics") as? Bool ?? true
        guard hapticsEnabled else { return }
        guard timeRemaining > 0 && timeRemaining <= 10 else { return }

        hapticGenerator.impactOccurred(intensity: 1.0)
        hapticGenerator.prepare()
    }
}
