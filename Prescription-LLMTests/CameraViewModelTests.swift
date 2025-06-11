import XCTest
@testable import Prescription_LLM

final class CameraViewModelTests: XCTestCase {
    
    func testCameraViewModelInitialization() {
        let viewModel = CameraViewModel()
        XCTAssertNil(viewModel.capturedImage)
        XCTAssertFalse(viewModel.showingImagePicker)
        XCTAssertFalse(viewModel.showingCamera)
        XCTAssertFalse(viewModel.hasImage)
    }
    
    func testSelectFromGallery() {
        let viewModel = CameraViewModel()
        viewModel.selectFromGallery()
        XCTAssertTrue(viewModel.showingImagePicker)
    }
    
    func testOpenCamera() {
        let viewModel = CameraViewModel()
        viewModel.openCamera()
        XCTAssertTrue(viewModel.showingCamera)
    }
}