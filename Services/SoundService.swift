import Foundation
import SwiftUI

class SoundService: ObservableObject {
    @Published var isMuted = true
    @Published var volume: Float = 0.0

    func playAmbient() { }
    func stopAmbient() { }
    func setMuted(_ muted: Bool) { isMuted = muted }
    func updateOutputVolume(intensity: Double) { }
    func shutdownAudio() { }
}
