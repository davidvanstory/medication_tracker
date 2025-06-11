import SwiftUI

struct PrescriptionListView: View {
    @StateObject private var viewModel = PrescriptionListViewModel()
    @State private var showingScanner = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.prescriptions) { prescription in
                    NavigationLink(destination: PrescriptionDetailView(prescription: prescription)) {
                        PrescriptionRowView(prescription: prescription)
                    }
                }
            }
            .navigationTitle("Prescriptions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingScanner = true }) {
                        Image(systemName: "doc.viewfinder")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingScanner) {
                PrescriptionScannerView()
            }
        }
    }
}

struct PrescriptionRowView: View {
    let prescription: Prescription
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(prescription.medications.first?.name ?? "Unknown Medication")
                .font(.headline)
            
            Text(prescription.timestamp, style: .date)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(prescription.medications.count) medications")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    PrescriptionListView()
} 