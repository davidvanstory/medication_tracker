import Foundation

@MainActor
class PrescriptionListViewModel: ObservableObject {
    @Published var prescriptions: [Prescription] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    init() {
        loadPrescriptions()
    }
    
    func loadPrescriptions() {
        // TODO: Load from local storage or API
        // For now, using sample data
        prescriptions = [
            Prescription(
                extractedText: "Sample prescription text",
                explanation: "This is a sample prescription explanation",
                medications: [
                    Medication(
                        name: "Amoxicillin",
                        dosage: "500mg",
                        frequency: "Twice daily",
                        instructions: "Take with food"
                    )
                ],
                timestamp: Date()
            )
        ]
    }
    
    func addPrescription(_ prescription: Prescription) {
        prescriptions.insert(prescription, at: 0)
        // TODO: Save to local storage or API
    }
} 