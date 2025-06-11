import SwiftUI

struct LoadingView: View {
    let message: String
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        VStack(spacing: 20) {
            // Spinning circle animation
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.blue, lineWidth: 4)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(rotationAngle))
                .onAppear {
                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                }
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct PulsingLoadingView: View {
    let message: String
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 20) {
            // Pulsing dots
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 12)
                        .scaleEffect(scale)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: scale
                        )
                }
            }
            .onAppear {
                scale = 1.2
            }
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    VStack(spacing: 40) {
        LoadingView(message: "Analyzing prescription...")
        
        Divider()
        
        PulsingLoadingView(message: "Processing with AI...")
    }
}