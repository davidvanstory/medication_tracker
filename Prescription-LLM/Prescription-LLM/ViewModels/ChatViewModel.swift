import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let networkManager = NetworkManager.shared
    
    func sendMessage(_ content: String) {
        let userMessage = ChatMessage(content: content, isUser: true, timestamp: Date())
        messages.append(userMessage)
        
        Task {
            await processMessage(content)
        }
    }
    
    private func processMessage(_ content: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // TODO: Send to API for processing
            // For now, using mock response
            let response = "I understand you're asking about \(content). This is a sample response."
            
            let botMessage = ChatMessage(
                content: response,
                isUser: false,
                timestamp: Date()
            )
            
            messages.append(botMessage)
            
        } catch {
            self.error = error
            let errorMessage = ChatMessage(
                content: "Sorry, I encountered an error: \(error.localizedDescription)",
                isUser: false,
                timestamp: Date()
            )
            messages.append(errorMessage)
        }
    }
} 