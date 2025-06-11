# iOS Project Structure

## Xcode Project Organization

```
Prescription-LLM/
├── Prescription-LLM/
│   ├── App/
│   │   ├── Prescription-LLMApp.swift
│   │   ├── ContentView.swift
│   │   └── AppDelegate.swift (if needed)
│   │
│   ├── Views/
│   │   ├── Camera/
│   │   │   ├── CameraView.swift
│   │   │   ├── CameraViewController.swift
│   │   │   └── ImagePreviewView.swift
│   │   ├── Processing/
│   │   │   ├── ProcessingView.swift
│   │   │   └── LoadingIndicatorView.swift
│   │   ├── Results/
│   │   │   ├── ResultsView.swift
│   │   │   ├── PrescriptionCard.swift
│   │   │   └── ExplanationView.swift
│   │   ├── Chat/
│   │   │   ├── ChatView.swift
│   │   │   ├── MessageBubble.swift
│   │   │   └── ChatInputView.swift
│   │   └── Common/
│   │       ├── CustomButton.swift
│   │       ├── ErrorView.swift
│   │       └── NavigationBarStyle.swift
│   │
│   ├── ViewModels/
│   │   ├── CameraViewModel.swift
│   │   ├── ProcessingViewModel.swift
│   │   ├── ResultsViewModel.swift
│   │   └── ChatViewModel.swift
│   │
│   ├── Models/
│   │   ├── Prescription.swift
│   │   ├── Medication.swift
│   │   ├── ChatMessage.swift
│   │   ├── OCRResult.swift
│   │   └── APIModels/
│   │       ├── OCRRequest.swift
│   │       ├── OCRResponse.swift
│   │       ├── LLMRequest.swift
│   │       └── LLMResponse.swift
│   │
│   ├── Services/
│   │   ├── PrescriptionService.swift
│   │   ├── OCRService.swift
│   │   ├── LLMService.swift
│   │   ├── ImageProcessor.swift
│   │   └── ValidationService.swift
│   │
│   ├── Network/
│   │   ├── APIClient.swift
│   │   ├── NetworkManager.swift
│   │   ├── APIEndpoints.swift
│   │   └── NetworkError.swift
│   │
│   ├── Utilities/
│   │   ├── Extensions/
│   │   │   ├── UIImage+Extensions.swift
│   │   │   ├── View+Extensions.swift
│   │   │   └── String+Extensions.swift
│   │   ├── Constants.swift
│   │   ├── Logger.swift
│   │   └── ConfigManager.swift
│   │
│   └── Resources/
│       ├── Assets.xcassets
│       ├── Info.plist
│       ├── Localizable.strings
│       └── Colors.xcassets
│
├── Prescription-LLMTests/
│   ├── ViewModelTests/
│   ├── ServiceTests/
│   ├── NetworkTests/
│   └── UtilityTests/
│
├── Prescription-LLMUITests/
│   ├── CameraUITests.swift
│   ├── ProcessingUITests.swift
│   └── ChatUITests.swift
│
└── Packages/
    └── (Swift Package Dependencies)
```

## Key Files Overview

### App Layer
- **Prescription-LLMApp.swift**: Main app entry point, app lifecycle
- **ContentView.swift**: Root view and navigation setup

### Views (SwiftUI)
- **CameraView.swift**: Camera interface with capture functionality
- **ProcessingView.swift**: Loading states during OCR/LLM processing
- **ResultsView.swift**: Display prescription analysis results
- **ChatView.swift**: Interactive Q&A interface

### ViewModels (MVVM Pattern)
- **CameraViewModel.swift**: Camera operations, image capture logic
- **ProcessingViewModel.swift**: Orchestrates OCR and LLM requests
- **ResultsViewModel.swift**: Manages prescription data display
- **ChatViewModel.swift**: Handles chat messages and conversation state

### Models
- **Prescription.swift**: Core prescription data structure
- **ChatMessage.swift**: Chat message representation
- **OCRResult.swift**: OCR service response structure

### Services (Business Logic)
- **PrescriptionService.swift**: Main orchestration service
- **OCRService.swift**: Text extraction from images
- **LLMService.swift**: AI explanation and chat functionality
- **ImageProcessor.swift**: Image enhancement and preprocessing

### Network Layer
- **APIClient.swift**: HTTP client wrapper
- **NetworkManager.swift**: Network connectivity and error handling
- **APIEndpoints.swift**: API URL and endpoint configuration

## File Naming Conventions

### SwiftUI Views
- Use descriptive names ending with "View"
- Group related views in folders
- Example: `CameraView.swift`, `MessageBubble.swift`

### ViewModels
- Use the corresponding view name + "ViewModel"
- Example: `CameraViewModel.swift`, `ChatViewModel.swift`

### Services
- Use descriptive names ending with "Service"
- Focus on single responsibility
- Example: `OCRService.swift`, `ValidationService.swift`

### Models
- Use clear, domain-specific names
- Group related models in folders when needed
- Example: `Prescription.swift`, `APIModels/OCRRequest.swift`

## Dependency Management

### Swift Package Manager
```swift
// Package.swift dependencies
dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0"),
    .package(url: "https://github.com/apple/swift-log", from: "1.5.0")
]
```

### Recommended Packages
- **Alamofire**: Advanced networking (optional, can use URLSession)
- **SwiftLog**: Structured logging
- **AsyncImage**: Enhanced image loading (iOS 15+)

## Build Configuration

### Info.plist Keys
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to capture prescription images</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select prescription images</string>
```

### Build Settings
- iOS Deployment Target: 15.0
- Swift Language Version: 5.9
- Enable SwiftUI previews
- Configure API keys in build configuration

## Git Structure
```
.gitignore              # iOS/Xcode specific ignores
README.md              # Project overview and setup
REQUIREMENTS.md        # Detailed requirements
ARCHITECTURE.md        # System architecture
UI_DESIGN.md          # UI specifications
API_INTEGRATION.md    # API integration guide
DEVELOPMENT_SETUP.md  # Setup instructions
```

## Development Workflow

### Branch Strategy
- `main`: Production-ready code
- `develop`: Integration branch
- `feature/*`: Individual features
- `bugfix/*`: Bug fixes

### Code Organization Principles
1. **Separation of Concerns**: Each file has a single responsibility
2. **MVVM Pattern**: Clear separation between UI, business logic, and data
3. **Protocol-Oriented**: Use protocols for testability and flexibility
4. **SwiftUI Best Practices**: Utilize state management and data flow patterns