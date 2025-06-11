import Foundation

protocol LLMServiceProtocol {
    func explainPrescription(_ text: String) async throws -> String
    func answerQuestion(_ question: String, context: String) async throws -> String
}

class MockLLMService: LLMServiceProtocol {
    func explainPrescription(_ text: String) async throws -> String {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
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
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
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

class LLMService {
    static let shared: LLMServiceProtocol = MockLLMService()
}