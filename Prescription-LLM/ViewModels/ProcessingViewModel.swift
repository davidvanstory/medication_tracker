import SwiftUI
import UIKit
import Combine

@MainActor
class ProcessingViewModel: ObservableObject {
    @Published var processingState: ProcessingState = .idle
    @Published var progressMessage = "Initializing..."
    @Published var prescription: Prescription?
    @Published var errorMessage: String?
    
    private let prescriptionService = PrescriptionService.shared
    private var cancellables = Set<AnyCancellable>()
    
    func processImage(_ image: UIImage?) async {
        guard let image = image else {
            processingState = .failed(ProcessingError.noImage)
            return
        }
        
        processingState = .processing
        
        do {
            // Step 1: OCR Processing
            progressMessage = "Extracting text from image..."
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            let ocrResult = try await prescriptionService.extractText(from: image)
            
            // Step 2: LLM Processing
            progressMessage = "Analyzing prescription with AI..."
            try await Task.sleep(nanoseconds: 1_500_000_000)
            
            let explanation = try await prescriptionService.explainPrescription(ocrResult.extractedText)
            
            // Step 3: Parse and create prescription object
            progressMessage = "Preparing results..."
            try await Task.sleep(nanoseconds: 500_000_000)
            
            let medications = parseMedications(from: ocrResult.extractedText)
            
            prescription = Prescription(
                extractedText: ocrResult.extractedText,
                explanation: explanation,
                medications: medications,
                timestamp: Date()
            )
            
            processingState = .completed
            
        } catch {
            errorMessage = error.localizedDescription
            processingState = .failed(error)
        }
    }
    
    private func parseMedications(from text: String) -> [Medication] {
        // Simple parsing logic
        let lines = text.components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        var medications: [Medication] = []
        
        for line in lines {
            let components = line.components(separatedBy: " ")
            if components.count >= 2 {
                let name = components[0]
                let dosage = components.count > 1 ? components[1] : "As prescribed"
                let frequency = components.count > 2 ? components[2] : "As directed"
                let instructions = line
                
                medications.append(Medication(
                    name: name,
                    dosage: dosage,
                    frequency: frequency,
                    instructions: instructions
                ))
            }
        }
        
        if medications.isEmpty {
            medications.append(Medication(
                name: "Prescription Medication",
                dosage: "As prescribed",
                frequency: "As directed",
                instructions: "Follow your doctor's instructions"
            ))
        }
        
        return medications
    }
    
    var isProcessing: Bool {
        if case .processing = processingState {
            return true
        }
        return false
    }
    
    var isCompleted: Bool {
        if case .completed = processingState {
            return true
        }
        return false
    }
    
    var hasFailed: Bool {
        if case .failed = processingState {
            return true
        }
        return false
    }
}

enum ProcessingError: LocalizedError {
    case noImage
    case ocrFailed
    case llmFailed
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .noImage:
            return "No image provided for processing"
        case .ocrFailed:
            return "Failed to extract text from image"
        case .llmFailed:
            return "Failed to analyze prescription"
        case .networkError:
            return "Network connection error"
        }
    }
}