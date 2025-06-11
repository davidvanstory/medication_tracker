import Foundation
import UIKit
import Vision

class PrescriptionService: ObservableObject {
    static let shared = PrescriptionService()
    
    private let ocrService: OCRServiceProtocol
    private let llmService: LLMServiceProtocol
    
    private init() {
        // For MVP, use local OCR (Apple Vision)
        self.ocrService = AppleVisionOCRService()
        self.llmService = MockLLMService() // Use mock service for development
    }
    
    func extractText(from image: UIImage) async throws -> OCRResult {
        return try await ocrService.extractText(from: image)
    }
    
    func explainPrescription(_ text: String) async throws -> String {
        return try await llmService.explainPrescription(text)
    }
    
    func answerQuestion(_ question: String, context: String) async throws -> String {
        return try await llmService.answerQuestion(question, context: context)
    }
}

// MARK: - OCR Service Protocol
protocol OCRServiceProtocol {
    func extractText(from image: UIImage) async throws -> OCRResult
}

// MARK: - Apple Vision OCR Service
class AppleVisionOCRService: OCRServiceProtocol {
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
                
                let extractedText = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: "\n")
                
                if extractedText.isEmpty {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }
                
                let confidence = observations.first?.confidence ?? 0.0
                let boundingBoxes = observations.compactMap { observation -> TextBoundingBox? in
                    guard let candidate = observation.topCandidates(1).first else { return nil }
                    
                    // Convert normalized coordinates to image coordinates
                    let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
                    let boundingBox = observation.boundingBox
                    let rect = CGRect(
                        x: boundingBox.origin.x * imageSize.width,
                        y: (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height,
                        width: boundingBox.width * imageSize.width,
                        height: boundingBox.height * imageSize.height
                    )
                    
                    return TextBoundingBox(
                        text: candidate.string,
                        frame: rect,
                        confidence: candidate.confidence
                    )
                }
                
                let result = OCRResult(
                    extractedText: extractedText,
                    confidence: Double(confidence),
                    boundingBoxes: boundingBoxes
                )
                
                continuation.resume(returning: result)
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.recognitionLanguages = ["en-US"]
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
}

// MARK: - OCR Errors
enum OCRError: LocalizedError {
    case invalidImage
    case noTextFound
    case processingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Invalid image provided"
        case .noTextFound:
            return "No text found in image"
        case .processingFailed:
            return "OCR processing failed"
        }
    }
}