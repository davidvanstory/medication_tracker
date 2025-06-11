import Foundation

// MARK: - LLM Service Protocol
protocol LLMServiceProtocol {
    func explainPrescription(_ text: String) async throws -> String
    func answerQuestion(_ question: String, context: String) async throws -> String
}

// MARK: - Mock LLM Service (for development)
class MockLLMService: LLMServiceProtocol {
    func explainPrescription(_ text: String) async throws -> String {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        return """
        Based on the prescription text provided, here's what I can tell you:

        **Medications Identified:**
        The prescription appears to contain medication information that requires proper medical guidance for safe use.

        **General Guidance:**
        • Take medications exactly as prescribed by your healthcare provider
        • Follow the dosage instructions carefully
        • Be aware of potential side effects and interactions
        • Keep medications in their original containers
        • Store medications properly (away from heat, light, and moisture)

        **Important Reminders:**
        • Never share prescription medications with others
        • Complete the full course of treatment even if you feel better
        • Contact your healthcare provider if you experience unusual symptoms
        • Keep track of refill dates and quantities

        **Questions to Ask Your Healthcare Provider:**
        • What are the potential side effects of this medication?
        • Are there any foods or other medications I should avoid?
        • What should I do if I miss a dose?
        • How long will I need to take this medication?

        This analysis is for educational purposes only. Always consult with your healthcare provider or pharmacist for personalized medical advice.
        """
    }
    
    func answerQuestion(_ question: String, context: String) async throws -> String {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Simple keyword-based responses for common questions
        let lowercaseQuestion = question.lowercased()
        
        if lowercaseQuestion.contains("side effect") {
            return """
            Common side effects can vary depending on the specific medication, but generally may include:

            • Nausea or stomach upset
            • Dizziness or drowsiness
            • Headache
            • Changes in appetite
            • Skin reactions

            **Important:** This is general information only. For specific side effects related to your medication, please:
            • Read the medication guide provided with your prescription
            • Consult your pharmacist or healthcare provider
            • Contact your doctor immediately if you experience severe or concerning symptoms

            Every person responds differently to medications, so your experience may vary.
            """
        }
        
        if lowercaseQuestion.contains("take") || lowercaseQuestion.contains("dose") {
            return """
            For proper medication administration:

            **General Guidelines:**
            • Take exactly as prescribed - don't skip or double doses
            • Take at the same time each day for consistency
            • Follow food instructions (with food, on empty stomach, etc.)
            • Use the measuring device provided, not household spoons

            **If You Miss a Dose:**
            • Take it as soon as you remember
            • If it's almost time for the next dose, skip the missed dose
            • Never take two doses at once to "catch up"

            **Always refer to your prescription label and medication guide for specific instructions for your medication.**
            """
        }
        
        if lowercaseQuestion.contains("food") || lowercaseQuestion.contains("eat") {
            return """
            Medication and food interactions are important to consider:

            **General Food Guidelines:**
            • Some medications work better on an empty stomach
            • Others should be taken with food to reduce stomach irritation
            • Certain foods can interfere with medication absorption

            **Common Food Interactions:**
            • Dairy products can affect some antibiotics
            • Grapefruit can interact with many medications
            • Alcohol should generally be avoided with medications

            **For your specific medication, please check:**
            • The prescription label for food instructions
            • The medication information sheet
            • Ask your pharmacist about specific food interactions
            """
        }
        
        if lowercaseQuestion.contains("stop") || lowercaseQuestion.contains("finish") {
            return """
            About stopping or finishing your medication:

            **Important Rules:**
            • Never stop taking prescribed medication without consulting your healthcare provider
            • Complete the full course, even if you feel better
            • Stopping early can lead to treatment failure or resistance

            **When to Contact Your Doctor:**
            • If you're experiencing concerning side effects
            • If you want to stop the medication for any reason
            • If your symptoms aren't improving as expected
            • If you have questions about the treatment duration

            Your healthcare provider prescribed this medication for a specific reason and duration. They can best advise you on when and how to safely discontinue treatment.
            """
        }
        
        // Generic response for other questions
        return """
        Thank you for your question about your prescription. While I can provide general information, the best answer to your specific question would come from:

        **Healthcare Professionals:**
        • Your prescribing doctor
        • Your pharmacist
        • Your healthcare provider's nurse line

        **Reliable Resources:**
        • The medication information sheet provided with your prescription
        • FDA-approved drug information websites
        • Your healthcare provider's patient portal

        **For Immediate Concerns:**
        If you're experiencing any concerning symptoms or have urgent questions about your medication, please contact your healthcare provider or pharmacist right away.

        Is there a more specific aspect of your medication that you'd like general information about?
        """
    }
}

// MARK: - OpenAI LLM Service (for production)
class OpenAILLMService: LLMServiceProtocol {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func explainPrescription(_ text: String) async throws -> String {
        let prompt = """
        You are a medical assistant helping patients understand their prescriptions. Analyze this prescription text and provide a clear, patient-friendly explanation:

        Prescription text: \(text)

        Please provide:
        1. What medication(s) are prescribed
        2. What condition(s) they typically treat
        3. General dosage and frequency guidance
        4. Important safety reminders
        5. When to contact healthcare providers

        Keep the explanation clear, accurate, and emphasize the importance of following medical professional guidance.
        """
        
        return try await makeRequest(prompt: prompt)
    }
    
    func answerQuestion(_ question: String, context: String) async throws -> String {
        let prompt = """
        You are a medical assistant helping a patient understand their prescription. 

        Prescription context: \(context)

        Patient question: \(question)

        Please provide a helpful, accurate answer. Always emphasize consulting healthcare providers for medical decisions and personalized advice.
        """
        
        return try await makeRequest(prompt: prompt)
    }
    
    private func makeRequest(prompt: String) async throws -> String {
        let request = OpenAIRequest(
            model: "gpt-4",
            messages: [
                OpenAIMessage(role: "system", content: "You are a helpful medical assistant. Always emphasize the importance of consulting healthcare professionals."),
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

// MARK: - OpenAI API Models
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

// MARK: - LLM Errors
enum LLMError: LocalizedError {
    case apiError(Int)
    case noResponse
    case invalidRequest
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .apiError(let code):
            return "API error: \(code)"
        case .noResponse:
            return "No response from AI service"
        case .invalidRequest:
            return "Invalid request format"
        case .networkError:
            return "Network connection error"
        }
    }
}

// MARK: - Shared Instance
extension LLMService {
    static let shared: LLMServiceProtocol = {
        // Check if OpenAI API key is available
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String,
           !apiKey.isEmpty {
            return OpenAILLMService(apiKey: apiKey)
        } else {
            // Fall back to mock service for development
            return MockLLMService()
        }
    }()
}

class LLMService {
    // This class exists just to provide the shared instance
    // The actual implementations are in the protocol conforming classes above
}