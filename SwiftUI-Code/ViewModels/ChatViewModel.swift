import SwiftUI
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var currentMessage = ""
    @Published var isTyping = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    private let prescription: Prescription
    private let llmService = LLMService.shared
    
    init(prescription: Prescription) {
        self.prescription = prescription
        setupInitialMessage()
    }
    
    private func setupInitialMessage() {
        let welcomeMessage = ChatMessage(
            content: "Hi! I'm here to help you understand your prescription. Feel free to ask me any questions about your medications, dosage, side effects, or anything else related to your prescription.",
            isUser: false,
            timestamp: Date()
        )
        messages.append(welcomeMessage)
    }
    
    func sendMessage() {
        guard !currentMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let userMessage = ChatMessage(
            content: currentMessage,
            isUser: true,
            timestamp: Date()
        )
        
        messages.append(userMessage)
        let messageText = currentMessage
        currentMessage = ""
        
        Task {
            await generateResponse(for: messageText)
        }
    }
    
    private func generateResponse(for question: String) async {
        isTyping = true
        
        do {
            let response = try await llmService.answerQuestion(
                question,
                context: createContext()
            )
            
            let aiMessage = ChatMessage(
                content: response,
                isUser: false,
                timestamp: Date()
            )
            
            messages.append(aiMessage)
            
        } catch {
            errorMessage = "Sorry, I couldn't process your question. Please try again."
            showingError = true
        }
        
        isTyping = false
    }
    
    private func createContext() -> String {
        return """
        Prescription Analysis:
        
        Extracted Text: \(prescription.extractedText)
        
        AI Explanation: \(prescription.explanation)
        
        Medications:
        \(prescription.medications.map { "- \($0.name): \($0.dosage), \($0.frequency)" }.joined(separator: "\n"))
        """
    }
    
    func clearChat() {
        messages.removeAll()
        setupInitialMessage()
    }
    
    var hasMessages: Bool {
        messages.count > 1 // More than just the welcome message
    }
}