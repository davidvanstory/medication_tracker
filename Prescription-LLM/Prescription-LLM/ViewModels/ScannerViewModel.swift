import Foundation
import UIKit
import AVFoundation

@MainActor
class ScannerViewModel: ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var showingError = false
    @Published var errorMessage = ""
    
    private let networkManager = NetworkManager.shared
    
    func captureImage() {
        // TODO: Implement camera capture
        // For now, using sample image
        capturedImage = UIImage(systemName: "doc.text")
    }
    
    func processImage() async {
        guard let image = capturedImage else { return }
        
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