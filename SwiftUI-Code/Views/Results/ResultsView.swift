import SwiftUI

struct ResultsView: View {
    let prescription: Prescription
    @StateObject private var viewModel: ResultsViewModel
    
    init(prescription: Prescription) {
        self.prescription = prescription
        self._viewModel = StateObject(wrappedValue: ResultsViewModel(prescription: prescription))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with timestamp
                HStack {
                    VStack(alignment: .leading) {
                        Text("Analysis Results")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Analyzed on \(prescription.timestamp, style: .date)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: viewModel.openChat) {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right")
                            Text("Ask Questions")
                        }
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                
                // AI Explanation Card
                ExpandableCard(
                    title: "AI Explanation",
                    icon: "brain.head.profile",
                    isExpanded: viewModel.isSectionExpanded("explanation"),
                    onToggle: { viewModel.toggleSection("explanation") }
                ) {
                    Text(prescription.explanation)
                        .font(.body)
                        .lineSpacing(4)
                }
                
                // Medications Card
                ExpandableCard(
                    title: "Medications (\(prescription.medications.count))",
                    icon: "pills",
                    isExpanded: viewModel.isSectionExpanded("medications"),
                    onToggle: { viewModel.toggleSection("medications") }
                ) {
                    LazyVStack(spacing: 12) {
                        ForEach(prescription.medications) { medication in
                            MedicationCard(medication: medication)
                        }
                    }
                }
                
                // Extracted Text Card
                ExpandableCard(
                    title: "Extracted Text",
                    icon: "doc.text",
                    isExpanded: viewModel.isSectionExpanded("extracted"),
                    onToggle: { viewModel.toggleSection("extracted") }
                ) {
                    Text(prescription.extractedText)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // Safety Notice
                SafetyNoticeCard()
                
                Spacer(minLength: 100)
            }
            .padding(.vertical)
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showingChat) {
            ChatView(prescription: prescription)
        }
    }
}

struct ExpandableCard<Content: View>: View {
    let title: String
    let icon: String
    let isExpanded: Bool
    let onToggle: () -> Void
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: onToggle) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .buttonStyle(PlainButtonStyle())
            
            // Content
            if isExpanded {
                VStack {
                    content
                }
                .padding()
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}

struct MedicationCard: View {
    let medication: Medication
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(medication.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(medication.dosage)
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            
            HStack {
                Label(medication.frequency, systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Text(medication.instructions)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

struct SafetyNoticeCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                
                Text("Important Safety Notice")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("• This analysis is for informational purposes only")
                Text("• Always consult your healthcare provider")
                Text("• Do not change medication without medical advice")
                Text("• In case of emergency, contact your doctor immediately")
            }
            .font(.body)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        ResultsView(prescription: Prescription(
            extractedText: "Lisinopril 10mg\nTake once daily\nFor blood pressure",
            explanation: "This is a sample prescription explanation that would be provided by the AI system.",
            medications: [
                Medication(
                    name: "Lisinopril",
                    dosage: "10mg",
                    frequency: "Once daily",
                    instructions: "Take once daily for blood pressure management"
                )
            ],
            timestamp: Date()
        ))
    }
}