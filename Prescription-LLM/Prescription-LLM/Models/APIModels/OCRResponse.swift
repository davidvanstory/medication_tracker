import Foundation

struct GoogleVisionResponse: Codable {
    let responses: [GoogleVisionImageResponse]
}

struct GoogleVisionImageResponse: Codable {
    let textAnnotations: [GoogleVisionTextAnnotation]?
}

struct GoogleVisionTextAnnotation: Codable {
    let description: String
}