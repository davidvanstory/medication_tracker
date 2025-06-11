import Foundation

struct APIEndpoints {
    static let openAIBaseURL = "https://api.openai.com/v1"
    static let googleVisionBaseURL = "https://vision.googleapis.com/v1"
    
    struct OpenAI {
        static let chatCompletions = URL(string: "\(openAIBaseURL)/chat/completions")!
    }
    
    struct GoogleVision {
        static func annotateImages(apiKey: String) -> URL {
            return URL(string: "\(googleVisionBaseURL)/images:annotate?key=\(apiKey)")!
        }
    }
}

struct APIConfiguration {
    static let shared = APIConfiguration()
    
    private init() {}
    
    var openAIAPIKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String ?? ""
    }
    
    var googleVisionAPIKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "GOOGLE_VISION_API_KEY") as? String ?? ""
    }
    
    var useLocalOCR: Bool {
        return Bundle.main.object(forInfoDictionaryKey: "USE_LOCAL_OCR") as? Bool ?? true
    }
    
    var requestTimeout: TimeInterval { 30.0 }
    var resourceTimeout: TimeInterval { 60.0 }
    var maxRequestsPerMinute: Int { 60 }
    var maxRetryAttempts: Int { 3 }
    var retryDelay: TimeInterval { 1.0 }
}