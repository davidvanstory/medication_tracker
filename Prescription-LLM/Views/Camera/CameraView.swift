import SwiftUI

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Camera Preview Area
                ZStack {
                    Rectangle()
                        .fill(Color.black)
                        .aspectRatio(4/3, contentMode: .fit)
                    
                    if let image = viewModel.capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            
                            Text("Position prescription within frame")
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    
                    // Frame overlay for guidance
                    if viewModel.capturedImage == nil {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                            .frame(maxWidth: 280, maxHeight: 200)
                    }
                }
                
                Spacer()
                
                // Controls Section
                VStack(spacing: 24) {
                    // Primary Actions
                    HStack(spacing: 40) {
                        // Gallery Button
                        Button(action: viewModel.selectFromGallery) {
                            VStack(spacing: 8) {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.system(size: 24))
                                Text("Gallery")
                                    .font(.caption)
                            }
                        }
                        .foregroundColor(.blue)
                        
                        // Capture Button
                        Button(action: viewModel.openCamera) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 80, height: 80)
                                
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .frame(width: 70, height: 70)
                                
                                if viewModel.capturedImage != nil {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        
                        // Clear/Retake Button
                        Button(action: viewModel.clearImage) {
                            VStack(spacing: 8) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 24))
                                Text("Retake")
                                    .font(.caption)
                            }
                        }
                        .foregroundColor(viewModel.hasImage ? .orange : .gray)
                        .disabled(!viewModel.hasImage)
                    }
                    
                    // Next Button
                    NavigationLink(destination: ProcessingView(image: viewModel.capturedImage)) {
                        HStack {
                            Text("Analyze Prescription")
                                .font(.headline)
                            Image(systemName: "arrow.right")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.hasImage ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(!viewModel.hasImage)
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("Prescription Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(selectedImage: .constant(nil)) { image in
                    viewModel.handleImageSelection(image)
                }
            }
            .sheet(isPresented: $viewModel.showingCamera) {
                CameraCapture { image in
                    viewModel.handleImageSelection(image)
                }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error occurred")
            }
        }
    }
}

#Preview {
    CameraView()
}