import Foundation

struct APIEndpoints {
    
    // MARK: - Base URLs
    static let openAIBaseURL = "https://api.openai.com/v1"
    static let googleVisionBaseURL = "https://vision.googleapis.com/v1"
    
    // MARK: - OpenAI Endpoints
    struct OpenAI {
        static let chatCompletions = URL(string: "\(openAIBaseURL)/chat/completions")!
    }
    
    // MARK: - Google Vision Endpoints
    struct GoogleVision {
        static func annotateImages(apiKey: String) -> URL {
            return URL(string: "\(googleVisionBaseURL)/images:annotate?key=\(apiKey)")!
        }
    }
    
    // MARK: - Custom Backend Endpoints (if you build your own backend)
    struct CustomBackend {
        static let baseURL = "https://your-backend.com/api/v1"
        
        static let processImage = URL(string: "\(baseURL)/process-image")!
        static let explainPrescription = URL(string: "\(baseURL)/explain")!
        static let askQuestion = URL(string: "\(baseURL)/ask")!
    }
}

// MARK: - API Configuration
struct APIConfiguration {
    static let shared = APIConfiguration()
    
    private init() {}
    
    // API Keys from Info.plist or environment
    var openAIAPIKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String ?? ""
    }
    
    var googleVisionAPIKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "GOOGLE_VISION_API_KEY") as? String ?? ""
    }
    
    var useLocalOCR: Bool {
        return Bundle.main.object(forInfoDictionaryKey: "USE_LOCAL_OCR") as? Bool ?? true
    }
    
    var useProductionLLM: Bool {
        return !openAIAPIKey.isEmpty && openAIAPIKey != "your-api-key-here"
    }
    
    // Request timeouts
    var requestTimeout: TimeInterval { 30.0 }
    var resourceTimeout: TimeInterval { 60.0 }
    
    // Rate limiting
    var maxRequestsPerMinute: Int { 60 }
    
    // Retry configuration
    var maxRetryAttempts: Int { 3 }
    var retryDelay: TimeInterval { 1.0 }
}