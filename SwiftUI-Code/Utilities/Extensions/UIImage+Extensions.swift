import UIKit

extension UIImage {
    
    // MARK: - Image Quality
    
    /// Compress image to specified quality
    func compressed(quality: CGFloat = 0.8) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }
    
    /// Resize image to specified size
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Resize image maintaining aspect ratio to fit within max dimensions
    func resizedToFit(maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage? {
        let aspectRatio = size.width / size.height
        
        var newWidth: CGFloat
        var newHeight: CGFloat
        
        if size.width > size.height {
            newWidth = min(maxWidth, size.width)
            newHeight = newWidth / aspectRatio
        } else {
            newHeight = min(maxHeight, size.height)
            newWidth = newHeight * aspectRatio
        }
        
        return resized(to: CGSize(width: newWidth, height: newHeight))
    }
    
    // MARK: - Image Processing for OCR
    
    /// Enhance image for better OCR results
    func enhancedForOCR() -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let context = CIContext()
        
        // Apply filters to improve text recognition
        let filters: [CIFilter] = [
            // Increase contrast
            {
                let filter = CIFilter(name: "CIColorControls")!
                filter.setValue(ciImage, forKey: kCIInputImageKey)
                filter.setValue(1.2, forKey: kCIInputContrastKey) // Increase contrast
                filter.setValue(0.0, forKey: kCIInputSaturationKey) // Remove color (grayscale)
                return filter
            }(),
            
            // Sharpen
            {
                let filter = CIFilter(name: "CISharpenLuminance")!
                filter.setValue(0.4, forKey: kCIInputSharpnessKey)
                return filter
            }()
        ]
        
        var processedImage = ciImage
        
        for filter in filters {
            if let previousImage = filter.value(forKey: kCIInputImageKey) as? CIImage {
                filter.setValue(processedImage, forKey: kCIInputImageKey)
            } else {
                filter.setValue(processedImage, forKey: kCIInputImageKey)
            }
            
            if let outputImage = filter.outputImage {
                processedImage = outputImage
            }
        }
        
        guard let cgImage = context.createCGImage(processedImage, from: processedImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    /// Convert to grayscale for better text recognition
    func grayscale() -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let context = CIContext()
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.0, forKey: kCIInputSaturationKey)
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    // MARK: - Orientation
    
    /// Fix image orientation issues
    func fixedOrientation() -> UIImage? {
        if imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // MARK: - Utility
    
    /// Get image file size in bytes
    var fileSizeInBytes: Int {
        return jpegData(compressionQuality: 1.0)?.count ?? 0
    }
    
    /// Get image file size in MB
    var fileSizeInMB: Double {
        return Double(fileSizeInBytes) / (1024.0 * 1024.0)
    }
    
    /// Check if image is too large for processing
    var isTooLargeForProcessing: Bool {
        return fileSizeInMB > 10.0 // 10MB limit
    }
    
    /// Prepare image for API upload (resize and compress if needed)
    func preparedForUpload(maxSizeInMB: Double = 4.0) -> UIImage? {
        var processedImage = self
        
        // Fix orientation first
        processedImage = processedImage.fixedOrientation() ?? processedImage
        
        // Resize if too large
        let maxDimension: CGFloat = 2048
        if size.width > maxDimension || size.height > maxDimension {
            processedImage = processedImage.resizedToFit(
                maxWidth: maxDimension,
                maxHeight: maxDimension
            ) ?? processedImage
        }
        
        // Compress if file size is still too large
        var quality: CGFloat = 0.8
        while processedImage.fileSizeInMB > maxSizeInMB && quality > 0.1 {
            if let compressedData = processedImage.jpegData(compressionQuality: quality),
               let compressedImage = UIImage(data: compressedData) {
                processedImage = compressedImage
            }
            quality -= 0.1
        }
        
        return processedImage
    }
}