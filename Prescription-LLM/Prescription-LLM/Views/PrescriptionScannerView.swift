import SwiftUI
import AVFoundation

struct PrescriptionScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ScannerViewModel()
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if let image = viewModel.capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    Color.black
                        .overlay {
                            Text("No image captured")
                                .foregroundColor(.white)
                        }
                }
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: { showingImagePicker = true }) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        
                        Button(action: viewModel.captureImage) {
                            Image(systemName: "camera.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Scan Prescription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.capturedImage != nil {
                        Button("Process") {
                            Task {
                                await viewModel.processImage()
                                dismiss()
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $viewModel.capturedImage)
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
    }
}

#Preview {
    PrescriptionScannerView()
} 