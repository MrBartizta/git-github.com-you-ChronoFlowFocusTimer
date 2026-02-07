import SwiftUI

struct GlobeView: View {
    let intensity: Double
    @State private var pulse = false
    @State private var corePulse = false

    private var clamped: Double { max(0.0, min(1.0, intensity)) }
    private var ramp: Double { pow(clamped, 2.2) }

    var body: some View {
        let glowBoost = 0.7 + ramp * 1.8
        let ringAlpha = 0.5 + ramp * 1.0
        let coreAlpha = 0.85 + ramp * 1.15

        ZStack {
            // Hologram halo
            Circle()
                .stroke(Color.neonBlue.opacity(min(1.0, ringAlpha + 0.2)), lineWidth: 2.2)
                .frame(width: pulse ? 182 : 162, height: pulse ? 182 : 162)
                .shadow(color: Color.neonBlue.opacity(1.0), radius: pulse ? 48 : 24)
                .shadow(color: Color.neonBlue.opacity(0.9), radius: pulse ? 78 : 34)

            // Globe body
            Circle()
                .fill(LinearGradient(
                    colors: [Color.neonBlue.opacity(0.9 + ramp * 0.6), Color.neonBlue.opacity(0.18 + ramp * 0.25)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .overlay(
                    Circle()
                        .stroke(Color.neonBlue.opacity(0.85 + ramp * 0.6), lineWidth: 2.0)
                )
                .shadow(color: Color.neonBlue.opacity(min(1.0, glowBoost)), radius: pulse ? 66 : 28)
                .shadow(color: Color.neonBlue.opacity(0.95), radius: pulse ? 102 : 50)
                .scaleEffect(pulse ? 1.04 : 1.0)

            // Scanline shimmer
            VStack(spacing: 6) {
                ForEach(0..<10, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.white.opacity(0.06 + ramp * 0.08))
                        .frame(height: 1)
                }
            }
            .frame(width: 140, height: 140)
            .mask(Circle())

            // Latitudinal arcs
            ForEach(0..<4, id: \.self) { i in
                let inset = CGFloat(12 + i * 14)
                Ellipse()
                    .stroke(Color.white.opacity(0.1 + ramp * 0.14), lineWidth: 1)
                    .frame(width: 140 - inset, height: 140 - inset)
            }

            // Longitudinal arcs
            ForEach(0..<3, id: \.self) { i in
                let rotation = Double(i) * 30 - 30
                Ellipse()
                    .stroke(Color.white.opacity(0.1 + ramp * 0.14), lineWidth: 1)
                    .frame(width: 90, height: 140)
                    .rotationEffect(.degrees(rotation))
            }

            // Glow core
            Circle()
                .fill(Color.neonBlue.opacity(min(1.0, coreAlpha)))
                .frame(width: corePulse ? 98 : 70, height: corePulse ? 98 : 70)
                .blur(radius: corePulse ? 30 : 16)
                .shadow(color: Color.neonBlue.opacity(1.0), radius: corePulse ? 52 : 24)
                .shadow(color: Color.neonBlue.opacity(0.95), radius: corePulse ? 76 : 34)
        }
        .frame(width: 182, height: 182)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                pulse = true
            }
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                corePulse = true
            }
        }
    }
}
