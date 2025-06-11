import SwiftUI

struct AppConstants {
    static let appName = "Prescription Scanner"
    static let appVersion = "1.0.0"
    static let buildNumber = "1"
    
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 44
        static let padding: CGFloat = 16
        static let animationDuration: Double = 0.3
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Double = 0.1
    }
    
    struct API {
        static let requestTimeout: TimeInterval = 30.0
        static let uploadTimeout: TimeInterval = 60.0
        static let maxRetryAttempts = 3
        static let retryDelay: TimeInterval = 1.0
        static let maxImageSizeMB: Double = 4.0
        static let defaultImageQuality: CGFloat = 0.8
    }
}

extension Color {
    static let primaryBlue = Color.blue
    static let secondaryBlue = Color.blue.opacity(0.1)
    static let successGreen = Color.green
    static let warningOrange = Color.orange
    static let errorRed = Color.red
}

struct StringConstants {
    struct NavigationTitles {
        static let camera = "Prescription Scanner"
        static let processing = "Processing"
        static let results = "Results"
        static let chat = "Ask Questions"
    }
    
    struct Buttons {
        static let capture = "Capture"
        static let retake = "Retake"
        static let gallery = "Gallery"
        static let analyze = "Analyze Prescription"
        static let askQuestions = "Ask Questions"
        static let tryAgain = "Try Again"
        static let done = "Done"
        static let clear = "Clear"
    }
    
    struct Errors {
        static let genericError = "Something went wrong. Please try again."
        static let networkError = "Unable to connect. Please check your internet connection."
        static let imageProcessingError = "Failed to process the image. Please try again with a clearer photo."
        static let noImageError = "Please select or capture an image first."
    }
}