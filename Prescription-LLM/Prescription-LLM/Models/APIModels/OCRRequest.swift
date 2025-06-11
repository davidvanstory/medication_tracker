import Foundation

struct GoogleVisionRequest: Codable {
    let requests: [GoogleVisionImageRequest]
}

struct GoogleVisionImageRequest: Codable {
    let image: GoogleVisionImage
    let features: [GoogleVisionFeature]
}

struct GoogleVisionImage: Codable {
    let content: String?
}

struct GoogleVisionFeature: Codable {
    let type: String
    let maxResults: Int
}