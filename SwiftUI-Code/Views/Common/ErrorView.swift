import SwiftUI

struct ErrorView: View {
    let title: String
    let message: String
    let retryAction: (() -> Void)?
    let dismissAction: (() -> Void)?
    
    init(
        title: String = "Something went wrong",
        message: String,
        retryAction: (() -> Void)? = nil,
        dismissAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.retryAction = retryAction
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Error icon
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            // Error text
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Action buttons
            VStack(spacing: 12) {
                if let retryAction = retryAction {
                    Button("Try Again") {
                        retryAction()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                
                if let dismissAction = dismissAction {
                    Button("Dismiss") {
                        dismissAction()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
            }
        }
        .padding()
    }
}

struct NetworkErrorView: View {
    let retryAction: () -> Void
    let dismissAction: (() -> Void)?
    
    var body: some View {
        ErrorView(
            title: "Connection Error",
            message: "Unable to connect to the server. Please check your internet connection and try again.",
            retryAction: retryAction,
            dismissAction: dismissAction
        )
    }
}

struct ProcessingErrorView: View {
    let retryAction: () -> Void
    let dismissAction: (() -> Void)?
    
    var body: some View {
        ErrorView(
            title: "Processing Failed",
            message: "We couldn't process your prescription image. Please try again with a clearer image.",
            retryAction: retryAction,
            dismissAction: dismissAction
        )
    }
}

#Preview {
    VStack(spacing: 40) {
        ErrorView(
            message: "Something unexpected happened",
            retryAction: { print("Retry tapped") },
            dismissAction: { print("Dismiss tapped") }
        )
        
        Divider()
        
        NetworkErrorView(
            retryAction: { print("Retry network") },
            dismissAction: { print("Dismiss network") }
        )
        
        Divider()
        
        ProcessingErrorView(
            retryAction: { print("Retry processing") },
            dismissAction: nil
        )
    }
}