import Foundation
import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var selectedPreset: TimerPreset = TimerPreset.presets[0]
    @Published var timeRemaining: TimeInterval = 25 * 60
    @Published var isRunning = false
    @Published var progress: Double = 0
    @Published var isBreakTime = false
    @Published var showAlmostDoneAlert = false

    private var timer: Timer?
    private var totalTime: TimeInterval {
        TimeInterval((isBreakTime ? selectedPreset.breakMinutes : selectedPreset.focusMinutes) * 60)
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }

    func resetTimer() {
        isRunning = false
        timer?.invalidate()
        timeRemaining = totalTime
        progress = 0
        showAlmostDoneAlert = false
    }

    func skipBreak() {
        isBreakTime = false
        resetTimer()
    }

    private func tick() {
        guard timeRemaining > 0 else { return }

        timeRemaining -= 1
        if timeRemaining <= 0 {
            timeRemaining = 0
            progress = 1.0
            isRunning = false
            timer?.invalidate()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                self?.timerCompleted()
            }
            return
        }

        if timeRemaining == 10 {
            showAlmostDoneAlert = true
        }

        progress = 1.0 - (timeRemaining / totalTime)
    }

    private func timerCompleted() {
        if !isBreakTime {
            SessionStore.shared.addSession(minutes: selectedPreset.focusMinutes, presetName: selectedPreset.name)
            isBreakTime = true
        } else {
            isBreakTime = false
        }
        resetTimer()
    }
}
