import SwiftUI

struct ProcessingView: View {
    let image: UIImage?
    @StateObject private var viewModel = ProcessingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                
                // Image preview
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                
                // Processing animation and status
                VStack(spacing: 24) {
                    if viewModel.isProcessing {
                        // Loading animation
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                                .frame(width: 80, height: 80)
                            
                            Circle()
                                .trim(from: 0, to: 0.7)
                                .stroke(Color.blue, lineWidth: 8)
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(viewModel.isProcessing ? 360 : 0))
                                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: viewModel.isProcessing)
                        }
                        
                        Text(viewModel.progressMessage)
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                    } else if viewModel.isCompleted {
                        // Success animation
                        ZStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(viewModel.isCompleted ? 1.0 : 0.8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.isCompleted)
                        
                        Text("Analysis Complete!")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                    } else if viewModel.hasFailed {
                        // Error state
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "exclamationmark")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Processing Failed")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 16) {
                    if viewModel.isCompleted, let prescription = viewModel.prescription {
                        NavigationLink(destination: ResultsView(prescription: prescription)) {
                            HStack {
                                Text("View Results")
                                    .font(.headline)
                                Image(systemName: "arrow.right")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    
                    if viewModel.hasFailed {
                        Button("Try Again") {
                            Task {
                                await viewModel.processImage(image)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    Button("Back to Camera") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("Processing")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(viewModel.isProcessing)
            .task {
                await viewModel.processImage(image)
            }
        }
    }
}

#Preview {
    ProcessingView(image: nil)
}