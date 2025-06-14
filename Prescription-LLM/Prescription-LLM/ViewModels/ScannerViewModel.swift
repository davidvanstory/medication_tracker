import Foundation
import UIKit
import AVFoundation

@MainActor
class ScannerViewModel: ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var isProcessing = false
    
    let cameraManager = CameraManager()
    private let networkManager = NetworkManager.shared
    
    init() {
        setupCameraManager()
    }
    
    private func setupCameraManager() {
        cameraManager.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showingError = true
                self?.errorMessage = error.localizedDescription
            }
        
        cameraManager.$capturedImage
            .compactMap { $0 }
            .assign(to: &$capturedImage)
    }
    
    func startCamera() {
        cameraManager.startSession()
    }
    
    func stopCamera() {
        cameraManager.stopSession()
    }
    
    func captureImage() {
        cameraManager.capturePhoto()
    }
    
    func processImage() async {
        guard let image = capturedImage else { return }
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            // Convert image to data
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw NSError(domain: "ScannerViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
            }
            
            // TODO: Send to API for processing
            // For now, just showing success
            print("Image processed successfully")
            
        } catch {
            showingError = true
            errorMessage = error.localizedDescription
        }
    }
} 