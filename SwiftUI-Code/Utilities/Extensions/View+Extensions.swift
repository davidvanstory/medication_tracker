import SwiftUI

extension View {
    
    // MARK: - Navigation
    
    /// Hide keyboard when tapping outside
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Add tap gesture to hide keyboard
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            hideKeyboard()
        }
    }
    
    // MARK: - Conditional Modifiers
    
    /// Apply modifier conditionally
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Apply modifier conditionally with else clause
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
    
    // MARK: - Card Style
    
    /// Apply card-like appearance
    func cardStyle(padding: CGFloat = 16, cornerRadius: CGFloat = 12) -> some View {
        self
            .padding(padding)
            .background(Color(.systemBackground))
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    /// Apply filled card style with background color
    func filledCardStyle(
        backgroundColor: Color = Color(.systemGray6),
        padding: CGFloat = 16,
        cornerRadius: CGFloat = 12
    ) -> some View {
        self
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
    
    // MARK: - Loading States
    
    /// Show loading overlay
    func loadingOverlay(isLoading: Bool, message: String = "Loading...") -> some View {
        self.overlay(
            Group {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        LoadingView(message: message)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(radius: 4)
                            )
                    }
                }
            }
        )
    }
    
    // MARK: - Error States
    
    /// Show error overlay
    func errorOverlay(
        error: Error?,
        retryAction: @escaping () -> Void
    ) -> some View {
        self.overlay(
            Group {
                if let error = error {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        ErrorView(
                            message: error.localizedDescription,
                            retryAction: retryAction,
                            dismissAction: nil
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(radius: 4)
                        )
                        .padding()
                    }
                }
            }
        )
    }
    
    // MARK: - Accessibility
    
    /// Add accessibility label and hint
    func accessibility(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .if(hint != nil) { view in
                view.accessibilityHint(hint!)
            }
    }
    
    // MARK: - Animations
    
    /// Bounce animation
    func bounceAnimation(trigger: some Equatable) -> some View {
        self
            .scaleEffect(1.0)
            .animation(.interpolatingSpring(stiffness: 300, damping: 10), value: trigger)
    }
    
    /// Shake animation for errors
    func shakeAnimation(trigger: some Equatable) -> some View {
        self
            .offset(x: 0)
            .animation(.default.repeatCount(3).speed(6), value: trigger)
    }
    
    // MARK: - Safe Area
    
    /// Get safe area insets
    var safeAreaInsets: EdgeInsets {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        let safeAreaInsets = keyWindow?.safeAreaInsets ?? .zero
        
        return EdgeInsets(
            top: safeAreaInsets.top,
            leading: safeAreaInsets.left,
            bottom: safeAreaInsets.bottom,
            trailing: safeAreaInsets.right
        )
    }
    
    // MARK: - Device Detection
    
    /// Check if running on iPad
    var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// Check if running on iPhone
    var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    // MARK: - Debug
    
    /// Print view updates (for debugging)
    func debugPrint(_ message: String) -> some View {
        print("🔍 \(message)")
        return self
    }
    
    /// Add colored border for debugging layout
    func debugBorder(_ color: Color = .red, width: CGFloat = 1) -> some View {
        self.overlay(
            Rectangle()
                .stroke(color, lineWidth: width)
        )
    }
}