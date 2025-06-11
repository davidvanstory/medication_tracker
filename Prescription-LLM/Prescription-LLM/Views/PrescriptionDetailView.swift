import SwiftUI

struct PrescriptionDetailView: View {
    let prescription: Prescription
    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Medications Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Medications")
                        .font(.title2)
                        .bold()
                    
                    ForEach(prescription.medications) { medication in
                        MedicationCard(medication: medication)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Explanation Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Explanation")
                        .font(.title2)
                        .bold()
                    
                    Text(prescription.explanation)
                        .font(.body)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Chat Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Ask Questions")
                        .font(.title2)
                        .bold()
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                ChatBubble(message: message)
                            }
                        }
                    }
                    .frame(height: 300)
                    
                    HStack {
                        TextField("Ask about your prescription...", text: $messageText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: sendMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                        }
                        .disabled(messageText.isEmpty)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .padding()
        }
        .navigationTitle("Prescription Details")
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        viewModel.sendMessage(messageText)
        messageText = ""
    }
}

struct MedicationCard: View {
    let medication: Medication
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(medication.name)
                .font(.headline)
            
            HStack {
                Label(medication.dosage, systemImage: "pills")
                Spacer()
                Label(medication.frequency, systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Text(medication.instructions)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            Text(message.content)
                .padding()
                .background(message.isUser ? Color.blue : Color(.secondarySystemBackground))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(16)
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

#Preview {
    PrescriptionDetailView(prescription: Prescription(
        extractedText: "Sample text",
        explanation: "This is a sample prescription",
        medications: [
            Medication(
                name: "Amoxicillin",
                dosage: "500mg",
                frequency: "Twice daily",
                instructions: "Take with food"
            )
        ],
        timestamp: Date()
    ))
} 