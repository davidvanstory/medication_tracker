import UIKit

extension UIImage {
    func compressed(quality: CGFloat = 0.8) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }
    
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
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
    
    func fixedOrientation() -> UIImage? {
        if imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    var fileSizeInBytes: Int {
        return jpegData(compressionQuality: 1.0)?.count ?? 0
    }
    
    var fileSizeInMB: Double {
        return Double(fileSizeInBytes) / (1024.0 * 1024.0)
    }
    
    func preparedForUpload(maxSizeInMB: Double = 4.0) -> UIImage? {
        var processedImage = self
        
        processedImage = processedImage.fixedOrientation() ?? processedImage
        
        let maxDimension: CGFloat = 2048
        if size.width > maxDimension || size.height > maxDimension {
            processedImage = processedImage.resizedToFit(
                maxWidth: maxDimension,
                maxHeight: maxDimension
            ) ?? processedImage
        }
        
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