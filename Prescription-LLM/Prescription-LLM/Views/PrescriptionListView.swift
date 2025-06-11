import SwiftUI

struct PrescriptionListView: View {
    @StateObject private var viewModel = PrescriptionListViewModel()
    @State private var showingScanner = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.prescriptions) { prescription in
                        NavigationLink(destination: PrescriptionDetailView(prescription: prescription)) {
                            PrescriptionRowView(prescription: prescription)
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingScanner = true }) {
                            Image(systemName: "camera.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Prescriptions")
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