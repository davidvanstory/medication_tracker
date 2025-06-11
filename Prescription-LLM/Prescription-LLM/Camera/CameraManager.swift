import AVFoundation
import UIKit

class CameraManager: NSObject, ObservableObject {
    @Published var error: Error?
    @Published var capturedImage: UIImage?
    
    private let session = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override init() {
        super.init()
        setupCamera()
    }
    
    func setupCamera() {
        session.beginConfiguration()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoInput) else {
            error = NSError(domain: "CameraManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to setup camera"])
            return
        }
        
        session.addInput(videoInput)
        
        guard session.canAddOutput(photoOutput) else {
            error = NSError(domain: "CameraManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to setup photo output"])
            return
        }
        
        session.addOutput(photoOutput)
        session.commitConfiguration()
    }
    
    func startSession() {
        guard !session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    func stopSession() {
        guard session.isRunning else { return }
        session.stopRunning()
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func setupPreviewLayer(in view: UIView) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            self.error = error
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            self.error = NSError(domain: "CameraManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to process captured image"])
            return
        }
        
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
} 