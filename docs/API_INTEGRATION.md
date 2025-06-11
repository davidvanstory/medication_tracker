# API Integration Guide

## Overview
This guide covers integration patterns for OCR and LLM services, including code examples and best practices for the prescription scanning app.

## OCR Service Integration

### Option 1: Apple Vision Framework (Recommended for MVP)
**Pros**: Local processing, privacy-focused, no API costs
**Cons**: May have lower accuracy for handwritten text

```swift
import Vision
import UIKit

class AppleVisionOCRService: OCRService {
    func extractText(from image: UIImage) async throws -> OCRResult {
        guard let cgImage = image.cgImage else {
            throw OCRError.invalidImage
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }
                
                let recognizedText = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: " ")
                
                let result = OCRResult(
                    extractedText: recognizedText,
                    confidence: observations.first?.confidence ?? 0.0,
                    boundingBoxes: []
                )
                
                continuation.resume(returning: result)
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
}
```

### Option 2: Google Vision API
**Pros**: Higher accuracy, better handwriting recognition
**Cons**: Requires API key, costs money, sends data to Google

```swift
import Foundation

class GoogleVisionOCRService: OCRService {
    private let apiKey: String
    private let baseURL = "https://vision.googleapis.com/v1/images:annotate"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func extractText(from image: UIImage) async throws -> OCRResult {
        let base64Image = image.jpegData(compressionQuality: 0.8)?.base64EncodedString()
        
        let request = GoogleVisionRequest(
            requests: [
                GoogleVisionImageRequest(
                    image: GoogleVisionImage(content: base64Image),
                    features: [GoogleVisionFeature(type: "TEXT_DETECTION", maxResults: 1)]
                )
            ]
        )
        
        let url = URL(string: "\(baseURL)?key=\(apiKey)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let response = try JSONDecoder().decode(GoogleVisionResponse.self, from: data)
        
        guard let textAnnotation = response.responses.first?.textAnnotations?.first else {
            throw OCRError.noTextFound
        }
        
        return OCRResult(
            extractedText: textAnnotation.description,
            confidence: 1.0,
            boundingBoxes: []
        )
    }
}

// Supporting models for Google Vision API
struct GoogleVisionRequest: Codable {
    let requests: [GoogleVisionImageRequest]
}

struct GoogleVisionImageRequest: Codable {
    let image: GoogleVisionImage
    let features: [GoogleVisionFeature]
}

struct GoogleVisionImage: Codable {
    let content: String?
}

struct GoogleVisionFeature: Codable {
    let type: String
    let maxResults: Int
}

struct GoogleVisionResponse: Codable {
    let responses: [GoogleVisionImageResponse]
}

struct GoogleVisionImageResponse: Codable {
    let textAnnotations: [GoogleVisionTextAnnotation]?
}

struct GoogleVisionTextAnnotation: Codable {
    let description: String
}
```

## LLM Service Integration

### OpenAI GPT-4 Integration

```swift
import Foundation

class OpenAIService: LLMService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func explainPrescription(_ ocrText: String) async throws -> String {
        let prompt = """
        You are a medical assistant. Analyze this prescription text and provide a clear, patient-friendly explanation:
        
        Prescription text: \(ocrText)
        
        Please provide:
        1. What medication(s) are prescribed
        2. What condition(s) they treat
        3. How to take them (dosage, frequency, timing)
        4. Important side effects or warnings
        5. General safety information
        
        Keep the explanation clear and accessible for non-medical users.
        """
        
        return try await makeRequest(prompt: prompt)
    }
    
    func answerQuestion(_ question: String, context: String) async throws -> String {
        let prompt = """
        You are a medical assistant helping a patient understand their prescription.
        
        Prescription context: \(context)
        
        Patient question: \(question)
        
        Please provide a helpful, accurate answer. If the question is outside your scope or requires medical consultation, advise the patient to consult their healthcare provider.
        """
        
        return try await makeRequest(prompt: prompt)
    }
    
    private func makeRequest(prompt: String) async throws -> String {
        let request = OpenAIRequest(
            model: "gpt-4",
            messages: [
                OpenAIMessage(role: "user", content: prompt)
            ],
            maxTokens: 500,
            temperature: 0.3
        )
        
        var urlRequest = URLRequest(url: URL(string: baseURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            throw LLMError.apiError(httpResponse.statusCode)
        }
        
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        guard let message = openAIResponse.choices.first?.message.content else {
            throw LLMError.noResponse
        }
        
        return message
    }
}

// Supporting models for OpenAI API
struct OpenAIRequest: Codable {
    let model: String
    let messages: [OpenAIMessage]
    let maxTokens: Int
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case maxTokens = "max_tokens"
    }
}

struct OpenAIMessage: Codable {
    let role: String
    let content: String
}

struct OpenAIResponse: Codable {
    let choices: [OpenAIChoice]
}

struct OpenAIChoice: Codable {
    let message: OpenAIMessage
}
```

## Service Protocols

```swift
// OCR Service Protocol
protocol OCRService {
    func extractText(from image: UIImage) async throws -> OCRResult
}

// LLM Service Protocol
protocol LLMService {
    func explainPrescription(_ ocrText: String) async throws -> String
    func answerQuestion(_ question: String, context: String) async throws -> String
}

// Error Types
enum OCRError: Error {
    case invalidImage
    case noTextFound
    case processingFailed
}

enum LLMError: Error {
    case apiError(Int)
    case noResponse
    case invalidRequest
}
```

## Configuration Management

```swift
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
}

// Usage in service initialization
class ServiceContainer {
    lazy var ocrService: OCRService = {
        if APIConfiguration.shared.useLocalOCR {
            return AppleVisionOCRService()
        } else {
            return GoogleVisionOCRService(apiKey: APIConfiguration.shared.googleVisionAPIKey)
        }
    }()
    
    lazy var llmService: LLMService = {
        return OpenAIService(apiKey: APIConfiguration.shared.openAIAPIKey)
    }()
}
```

## Network Layer Implementation

```swift
class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    func request<T: Codable>(
        url: URL,
        method: HTTPMethod,
        body: Data? = nil,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 contains httpResponse.statusCode else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum NetworkError: Error {
    case invalidResponse
    case httpError(Int)
    case decodingError
}
```

## Best Practices

### API Key Security
1. Store API keys in Info.plist (not in code)
2. Use different keys for development/production
3. Add Info.plist to .gitignore for sensitive keys
4. Consider using iOS Keychain for production apps

### Error Handling
1. Implement retry logic with exponential backoff
2. Provide meaningful error messages to users
3. Log errors for debugging (without sensitive data)
4. Handle network connectivity issues gracefully

### Performance Optimization
1. Compress images before sending to APIs
2. Cache responses when appropriate
3. Use background queues for API calls
4. Implement request cancellation

### Testing Strategy
1. Mock API responses for unit tests
2. Use dependency injection for services
3. Test error scenarios
4. Implement integration tests for critical paths