import SwiftUI

// MARK: - App Constants
struct AppConstants {
    
    // MARK: - App Information
    static let appName = "Prescription Scanner"
    static let appVersion = "1.0.0"
    static let buildNumber = "1"
    
    // MARK: - UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 44
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
        
        static let animationDuration: Double = 0.3
        static let fastAnimationDuration: Double = 0.15
        static let slowAnimationDuration: Double = 0.6
        
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Double = 0.1
        
        // Image dimensions
        static let thumbnailSize: CGFloat = 80
        static let previewImageHeight: CGFloat = 200
        static let maxImageDimension: CGFloat = 2048
    }
    
    // MARK: - API Constants
    struct API {
        static let requestTimeout: TimeInterval = 30.0
        static let uploadTimeout: TimeInterval = 60.0
        static let maxRetryAttempts = 3
        static let retryDelay: TimeInterval = 1.0
        
        // Image processing
        static let maxImageSizeMB: Double = 4.0
        static let defaultImageQuality: CGFloat = 0.8
        static let ocrImageQuality: CGFloat = 0.9
    }
    
    // MARK: - Validation Constants
    struct Validation {
        static let minQuestionLength = 3
        static let maxQuestionLength = 500
        static let maxImageFileSizeMB: Double = 10.0
    }
    
    // MARK: - Feature Flags
    struct FeatureFlags {
        static let enableAdvancedOCR = false
        static let enableOfflineMode = false
        static let enableAnalytics = false
        static let enableCrashReporting = false
    }
}

// MARK: - Color Constants
extension Color {
    
    // MARK: - App Colors
    static let primaryBlue = Color.blue
    static let secondaryBlue = Color.blue.opacity(0.1)
    static let successGreen = Color.green
    static let warningOrange = Color.orange
    static let errorRed = Color.red
    
    // MARK: - Custom Colors
    static let cardBackground = Color(.systemBackground)
    static let sectionBackground = Color(.systemGray6)
    static let borderColor = Color(.systemGray4)
    
    // MARK: - Text Colors
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let tertiaryText = Color(.systemGray)
    
    // MARK: - Semantic Colors
    static let medicationCard = Color.blue.opacity(0.05)
    static let explanationCard = Color.green.opacity(0.05)
    static let warningCard = Color.orange.opacity(0.05)
}

// MARK: - Font Constants
extension Font {
    
    // MARK: - App Fonts
    static let appTitle = Font.largeTitle.bold()
    static let sectionTitle = Font.title2.bold()
    static let cardTitle = Font.headline
    static let bodyText = Font.body
    static let captionText = Font.caption
    static let buttonText = Font.headline
    
    // MARK: - Custom Fonts
    static let monospacedBody = Font.system(.body, design: .monospaced)
    static let roundedHeadline = Font.system(.headline, design: .rounded)
}

// MARK: - String Constants
struct StringConstants {
    
    // MARK: - Navigation Titles
    struct NavigationTitles {
        static let camera = "Prescription Scanner"
        static let processing = "Processing"
        static let results = "Results"
        static let chat = "Ask Questions"
    }
    
    // MARK: - Button Titles
    struct Buttons {
        static let capture = "Capture"
        static let retake = "Retake"
        static let gallery = "Gallery"
        static let analyze = "Analyze Prescription"
        static let askQuestions = "Ask Questions"
        static let tryAgain = "Try Again"
        static let done = "Done"
        static let clear = "Clear"
        static let dismiss = "Dismiss"
    }
    
    // MARK: - Error Messages
    struct Errors {
        static let genericError = "Something went wrong. Please try again."
        static let networkError = "Unable to connect. Please check your internet connection."
        static let imageProcessingError = "Failed to process the image. Please try again with a clearer photo."
        static let ocrError = "Could not extract text from the image. Please ensure the prescription is clearly visible."
        static let llmError = "Could not generate explanation. Please try again."
        static let noImageError = "Please select or capture an image first."
        static let imageTooLargeError = "The image is too large. Please try with a smaller image."
    }
    
    // MARK: - Loading Messages
    struct LoadingMessages {
        static let initializing = "Initializing..."
        static let extractingText = "Extracting text from image..."
        static let analyzingPrescription = "Analyzing prescription with AI..."
        static let preparingResults = "Preparing results..."
        static let generatingResponse = "Generating response..."
    }
    
    // MARK: - Placeholder Text
    struct Placeholders {
        static let cameraGuide = "Position prescription within frame"
        static let chatInput = "Ask a question..."
        static let noResults = "No results available"
        static let noMessages = "No messages yet"
    }
    
    // MARK: - Safety Notices
    struct SafetyNotices {
        static let disclaimer = """
        This analysis is for informational purposes only. Always consult your healthcare provider for medical advice.
        """
        
        static let emergencyNotice = """
        In case of medical emergency, contact your doctor immediately or call emergency services.
        """
        
        static let fullDisclaimer = """
        • This analysis is for informational purposes only
        • Always consult your healthcare provider
        • Do not change medication without medical advice
        • In case of emergency, contact your doctor immediately
        """
    }
}

// MARK: - Accessibility Constants
struct AccessibilityConstants {
    
    // MARK: - Identifiers
    struct Identifiers {
        static let cameraButton = "camera_capture_button"
        static let galleryButton = "gallery_select_button"
        static let retakeButton = "retake_button"
        static let analyzeButton = "analyze_button"
        static let chatInput = "chat_input_field"
        static let sendButton = "send_message_button"
    }
    
    // MARK: - Labels
    struct Labels {
        static let cameraCapture = "Capture prescription image"
        static let gallerySelect = "Select image from gallery"
        static let retakePhoto = "Retake photo"
        static let analyzeImage = "Analyze prescription"
        static let chatInput = "Type your question"
        static let sendMessage = "Send message"
    }
    
    // MARK: - Hints
    struct Hints {
        static let cameraCapture = "Take a photo of your prescription"
        static let gallerySelect = "Choose an existing photo from your gallery"
        static let analyzeImage = "Process the captured image to extract prescription information"
        static let chatInput = "Ask questions about your prescription"
    }
}