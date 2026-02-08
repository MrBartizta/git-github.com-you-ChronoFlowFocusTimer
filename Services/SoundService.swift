import Foundation
import SwiftUI
import AVFoundation

class SoundService: ObservableObject {
    static let availableAmbientSounds = [
        "grand_project-breath-of-life_60-seconds-320857"
    ]

    @Published var volume: Float = 0.5 {
        didSet {
            updateVolume(volume)
        }
    }

    private var player: AVAudioPlayer?
    private var currentSoundName: String?

    func playAmbient(soundName: String, volume: Float) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Ignore audio session errors; playback may still work.
        }

        if currentSoundName != soundName || player == nil {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = -1
                player?.prepareToPlay()
                currentSoundName = soundName
            } catch {
                player = nil
                currentSoundName = nil
                return
            }
        }

        player?.volume = max(0.0, min(1.0, volume))
        player?.play()
    }

    func stopAmbient() {
        player?.stop()
    }

    func updateVolume(_ volume: Float) {
        player?.volume = max(0.0, min(1.0, volume))
    }

    func shutdownAudio() {
        stopAmbient()
        player = nil
        currentSoundName = nil
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            // Ignore
        }
    }
}
