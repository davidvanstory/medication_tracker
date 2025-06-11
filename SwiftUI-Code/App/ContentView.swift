import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            CameraView()
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures single view on iPad
    }
}

#Preview {
    ContentView()
}