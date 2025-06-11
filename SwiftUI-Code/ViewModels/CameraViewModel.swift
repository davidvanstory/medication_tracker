import SwiftUI
import UIKit
import Combine

@MainActor
class CameraViewModel: ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var showingImagePicker = false
    @Published var showingCamera = false
    @Published var errorMessage: String?
    @Published var showingError = false
    
    func selectFromGallery() {
        showingImagePicker = true
    }
    
    func openCamera() {
        showingCamera = true
    }
    
    func clearImage() {
        capturedImage = nil
    }
    
    func handleImageSelection(_ image: UIImage?) {
        capturedImage = image
        showingImagePicker = false
        showingCamera = false
    }
    
    func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
    
    var hasImage: Bool {
        capturedImage != nil
    }
}