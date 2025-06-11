# Development Setup Guide

## Prerequisites

### Required Software
1. **Xcode 15.0+** - Download from Mac App Store or Apple Developer Portal
2. **iOS 15.0+ SDK** - Included with Xcode
3. **macOS 13.0+** - For Xcode compatibility
4. **Git** - For version control

### Optional Tools
- **SF Symbols App** - For iOS icon design
- **Simulator** - iOS Simulator (included with Xcode)
- **TestFlight** - For beta testing (later)

## Project Setup

### 1. Create New Xcode Project
```bash
# Open Xcode and create new project
# Choose: iOS > App
# Product Name: Prescription-LLM
# Interface: SwiftUI
# Language: Swift
# Use Core Data: No (for MVP)
# Include Tests: Yes
```

### 2. Project Configuration
**General Settings:**
- Bundle Identifier: `com.yourteam.Prescription-LLM`
- Deployment Target: iOS 15.0
- Device Orientation: Portrait (primary)
- Status Bar Style: Default

**Build Settings:**
- Swift Language Version: Swift 5
- Enable SwiftUI Previews: Yes
- Build Configuration: Debug/Release

### 3. Info.plist Configuration
Add required permissions and API keys:

```xml
<!-- Camera Permission -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to capture prescription images for analysis</string>

<!-- Photo Library Permission -->
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select prescription images</string>

<!-- API Keys (DO NOT commit to git) -->
<key>OPENAI_API_KEY</key>
<string>$(OPENAI_API_KEY)</string>

<key>GOOGLE_VISION_API_KEY</key>
<string>$(GOOGLE_VISION_API_KEY)</string>

<key>USE_LOCAL_OCR</key>
<true/>
```

### 4. Build Configuration
Create configuration files for different environments:

**Debug.xcconfig:**
```
OPENAI_API_KEY = your_development_api_key_here
GOOGLE_VISION_API_KEY = your_development_google_key_here
USE_LOCAL_OCR = YES
```

**Release.xcconfig:**
```
OPENAI_API_KEY = your_production_api_key_here
GOOGLE_VISION_API_KEY = your_production_google_key_here
USE_LOCAL_OCR = NO
```

## API Keys Setup

### 1. OpenAI API Key
1. Go to [OpenAI API Platform](https://platform.openai.com)
2. Create account or sign in
3. Navigate to API Keys section
4. Create new secret key
5. Copy key to your configuration file

**Pricing Estimate for MVP:**
- GPT-4: ~$0.03 per 1K tokens
- Expected cost: $5-20/month for testing

### 2. Google Vision API (Optional)
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create new project or select existing
3. Enable Vision API
4. Create credentials (API Key)
5. Copy key to your configuration file

**Pricing Estimate:**
- OCR: $1.50 per 1,000 images
- Expected cost: $10-30/month for testing

## Dependencies Management

### Swift Package Manager
Add dependencies in Xcode:
1. File > Add Package Dependencies
2. Add the following URLs:

**Optional Packages:**
```
https://github.com/Alamofire/Alamofire (5.8.0+)
https://github.com/apple/swift-log (1.5.0+)
```

### Package.swift (if using SPM)
```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Prescription-LLM",
    platforms: [
        .iOS(.v15)
    ],
    dependencies: [
        // Add external dependencies here if needed
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0")
    ],
    targets: [
        .target(
            name: "Prescription-LLM",
            dependencies: []
        )
    ]
)
```

## Simulator Setup

### Recommended Simulators
1. **iPhone 14 Pro** - Primary development device
2. **iPhone SE (3rd generation)** - Smaller screen testing
3. **iPad Air (5th generation)** - Tablet support (future)

### Simulator Configuration
```bash
# List available simulators
xcrun simctl list devices

# Boot specific simulator
xcrun simctl boot "iPhone 14 Pro"

# Add sample photos to simulator
# Drag and drop images into Photos app
# Or use: xcrun simctl addmedia [device] [path-to-image]
```

## Development Workflow

### 1. Initial Project Structure
Create the folder structure according to `PROJECT_STRUCTURE.md`:

```bash
mkdir -p Prescription-LLM/{App,Views/{Camera,Processing,Results,Chat,Common},ViewModels,Models/{APIModels},Services,Network,Utilities/{Extensions},Resources}
```

### 2. Git Setup
```bash
# Initialize git repository
git init

# Create .gitignore
echo "# Xcode
*.xcodeproj/*
!*.xcodeproj/project.pbxproj
!*.xcodeproj/xcshareddata/
!*.xcodeproj/project.xcworkspace/
*.xcworkspace/*
!*.xcworkspace/contents.xcworkspacedata
*.swp
*.lock
*~.nib
DerivedData/
.DS_Store
*.ipa
*.xcarchive

# API Keys
Debug.xcconfig
Release.xcconfig
Config.plist" > .gitignore

# Initial commit
git add .
git commit -m "Initial project setup"
```

### 3. Development Process
1. **Start with UI**: Build SwiftUI views and navigation
2. **Add Mock Data**: Create sample data for UI testing
3. **Implement Services**: Add OCR and LLM integration
4. **Testing**: Unit tests and UI tests
5. **Refinement**: Polish UI and error handling

## Testing Setup

### Unit Tests
Create test files following the structure:
```
Prescription-LLMTests/
├── ViewModelTests/
│   ├── CameraViewModelTests.swift
│   └── ProcessingViewModelTests.swift
├── ServiceTests/
│   ├── OCRServiceTests.swift
│   └── LLMServiceTests.swift
└── NetworkTests/
    └── APIClientTests.swift
```

### UI Tests
```swift
// Example UI test structure
class Prescription-LLMUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testCameraFlow() throws {
        // Test camera interface and image capture
    }
}
```

## Common Issues & Solutions

### 1. Camera Not Working in Simulator
**Issue**: Camera interface shows black screen
**Solution**: Use "Device > Photos" to add sample images, or test on physical device

### 2. API Keys Not Loading
**Issue**: API calls return authentication errors
**Solution**: Verify Info.plist configuration and build settings

### 3. SwiftUI Preview Issues
**Issue**: Previews not working or crashing
**Solution**: Ensure mock data is available and dependencies are properly injected

### 4. Build Errors with Dependencies
**Issue**: Package resolution failures
**Solution**: Clean build folder (⌘+Shift+K) and reset package caches

## Performance Testing

### Memory Usage
```swift
// Monitor memory usage during image processing
func logMemoryUsage() {
    let memoryUsage = mach_task_basic_info()
    // Log memory statistics
}
```

### Image Processing Performance
```swift
// Measure OCR processing time
func measureOCRPerformance() {
    let startTime = CFAbsoluteTimeGetCurrent()
    // Perform OCR
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("OCR processing time: \(timeElapsed) seconds")
}
```

## Deployment Preparation

### 1. App Store Connect Setup
1. Create App Store Connect account
2. Create new app record
3. Configure app metadata
4. Prepare app screenshots

### 2. TestFlight Setup
1. Archive app for distribution
2. Upload to App Store Connect
3. Add beta testers
4. Distribute beta builds

### 3. Privacy & Security
- Review data collection practices
- Update privacy policy
- Implement data retention policies
- Security audit for API integrations

## Next Steps After Setup

1. **Build Basic UI**: Start with CameraView and navigation
2. **Implement Mock Services**: Create fake OCR/LLM responses
3. **Test User Flow**: Ensure complete app navigation works
4. **Add Real APIs**: Integrate actual OCR and LLM services
5. **Polish & Test**: Refine UI and add comprehensive testing

## Resources

### Documentation
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Vision Framework Guide](https://developer.apple.com/documentation/vision)

### Communities
- [Swift Forums](https://forums.swift.org)
- [iOS Dev Reddit](https://reddit.com/r/iOSProgramming)
- [Stack Overflow - SwiftUI](https://stackoverflow.com/questions/tagged/swiftui)