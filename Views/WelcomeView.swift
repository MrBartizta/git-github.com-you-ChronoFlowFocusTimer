import SwiftUI

struct WelcomeView: View {
    @State private var appear = false
    @State private var spin = false

    var body: some View {
        ZStack {
            LinearGradient.neonBackground
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Image("AppLogo")
                    .resizable()
                    .frame(width: 92, height: 92)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.neonBlue.opacity(0.7), radius: 18)
                    .scaleEffect(appear ? 1.0 : 0.9)
                    .rotationEffect(.degrees(spin ? 360 : 0))

                Text("ChronoFlow")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.white)

                Text("Focus, in motion")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(26)
            .glassCard(cornerRadius: 22)
            .opacity(appear ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                appear = true
            }
            withAnimation(.easeInOut(duration: 1.0)) {
                spin = true
            }
        }
    }
}
