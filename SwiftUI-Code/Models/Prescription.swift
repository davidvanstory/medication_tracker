import Foundation
import UIKit

struct Prescription: Identifiable, Codable {
    let id = UUID()
    let extractedText: String
    let explanation: String
    let medications: [Medication]
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case extractedText, explanation, medications, timestamp
    }
}

struct Medication: Identifiable, Codable {
    let id = UUID()
    let name: String
    let dosage: String
    let frequency: String
    let instructions: String
    
    enum CodingKeys: String, CodingKey {
        case name, dosage, frequency, instructions
    }
}

struct OCRResult {
    let extractedText: String
    let confidence: Double
    let boundingBoxes: [TextBoundingBox]
}

struct TextBoundingBox {
    let text: String
    let frame: CGRect
    let confidence: Double
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

enum ProcessingState {
    case idle
    case processing
    case completed
    case failed(Error)
}