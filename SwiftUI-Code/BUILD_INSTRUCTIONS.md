# Build Instructions for Prescription Scanner App

## 📋 Quick Setup Checklist

- [ ] Xcode 15.0+ installed
- [ ] iOS 15.0+ deployment target
- [ ] Camera and Photo Library permissions configured
- [ ] API keys configured (optional for MVP)
- [ ] All source files added to Xcode project

## 🚀 Step-by-Step Build Instructions

### 1. Create New Xcode Project

1. Open Xcode
2. File → New → Project
3. Choose **iOS** → **App**
4. Configure project:
   - Product Name: `Prescription-LLM`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Use Core Data: **NO**
   - Include Tests: **YES**

### 2. Project Structure Setup

Create the following group structure in Xcode:

```
Prescription-LLM/
├── App/
├── Views/
│   ├── Camera/
│   ├── Processing/
│   ├── Results/
│   ├── Chat/
│   └── Common/
├── ViewModels/
├── Models/
├── Services/
├── Network/
├── Utilities/
│   └── Extensions/
└── Resources/
```

### 3. Add Source Files

Copy all `.swift` files from the `SwiftUI-Code/` directory to your Xcode project:

**Core App Files:**
- `App/Prescription-LLMApp.swift`
- `App/ContentView.swift`

**Models:**
- `Models/Prescription.swift`

**Views:**
- `Views/Camera/CameraView.swift`
- `Views/Camera/ImagePicker.swift`
- `Views/Camera/CameraCapture.swift`
- `Views/Processing/ProcessingView.swift`
- `Views/Results/ResultsView.swift`
- `Views/Chat/ChatView.swift`
- `Views/Common/LoadingView.swift`
- `Views/Common/ErrorView.swift`
- `Views/Common/ButtonStyles.swift`

**ViewModels:**
- `ViewModels/CameraViewModel.swift`
- `ViewModels/ProcessingViewModel.swift`
- `ViewModels/ResultsViewModel.swift`
- `ViewModels/ChatViewModel.swift`

**Services:**
- `Services/PrescriptionService.swift`
- `Services/LLMService.swift`

**Network:**
- `Network/NetworkManager.swift`
- `Network/APIEndpoints.swift`

**Utilities:**
- `Utilities/Constants.swift`
- `Utilities/Extensions/UIImage+Extensions.swift`
- `Utilities/Extensions/View+Extensions.swift`

### 4. Configure Info.plist

Add the following permissions to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to capture prescription images for analysis</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select prescription images</string>

<!-- Optional: API Keys for production -->
<key>OPENAI_API_KEY</key>
<string>$(OPENAI_API_KEY)</string>

<key>GOOGLE_VISION_API_KEY</key>
<string>$(GOOGLE_VISION_API_KEY)</string>

<key>USE_LOCAL_OCR</key>
<true/>
```

### 5. Build Configuration

**Minimum Requirements:**
- iOS Deployment Target: 15.0
- Swift Language Version: 5.9
- Xcode Version: 15.0+

**Build Settings:**
1. Select your project in navigator
2. Go to Build Settings
3. Set "iOS Deployment Target" to 15.0
4. Ensure "Swift Language Version" is set to Swift 5

### 6. Dependencies (Optional)

For this MVP, we're using only native iOS frameworks:
- SwiftUI (UI framework)
- Vision (OCR processing)
- PhotosUI (Image selection)
- Foundation (Core functionality)

No external dependencies required!

## 🧪 Testing the Build

### 1. Build for Simulator

1. Select iPhone 14 Pro simulator
2. Press **⌘+B** to build
3. Press **⌘+R** to run

Expected behavior:
- App launches with camera view
- Can select images from gallery
- Processing view shows loading animation
- Results display with mock explanation
- Chat interface responds with mock AI

### 2. Common Build Issues & Solutions

#### Issue: "Cannot find 'CameraView' in scope"
**Solution:** Ensure all view files are added to the Xcode target

#### Issue: "Use of undeclared type 'Prescription'"
**Solution:** Add `Models/Prescription.swift` to your project

#### Issue: "Camera not working in simulator"
**Solution:** This is normal - use "Gallery" button to select test images

#### Issue: Permission alerts not showing
**Solution:** Verify Info.plist has camera/photo permissions

### 3. Test Image Preparation

For simulator testing:
1. Download sample prescription images
2. Drag them into iOS Simulator's Photos app
3. Use "Gallery" button in app to select them

## 🔧 Development Workflow

### Phase 1: Static UI (Week 1)
- Build and test all views
- Verify navigation works
- Test with mock data

### Phase 2: OCR Integration (Week 2)
- Test Apple Vision Framework
- Validate text extraction
- Handle OCR errors

### Phase 3: LLM Integration (Week 3)
- Add OpenAI API key
- Test real AI responses
- Implement error handling

### Phase 4: Polish (Week 4)
- UI refinements
- Performance optimization
- Comprehensive testing

## 🚨 Known Limitations (MVP)

1. **Camera in Simulator**: Use gallery selection for testing
2. **Mock AI Responses**: Replace with real API integration later
3. **No Data Persistence**: Images/results aren't saved
4. **Basic Error Handling**: Minimal error recovery
5. **No Offline Mode**: Requires internet for AI features

## 📱 Testing on Physical Device

To test camera functionality:

1. Connect iPhone via USB
2. Select your device in Xcode
3. Build and run (⌘+R)
4. Trust developer certificate on device
5. Test camera capture functionality

## 🔐 Production Considerations

Before App Store release:
- [ ] Add proper API key management
- [ ] Implement comprehensive error handling
- [ ] Add analytics and crash reporting
- [ ] Security audit for API integrations
- [ ] Performance optimization
- [ ] Accessibility testing
- [ ] App Store screenshots and metadata

## 🆘 Troubleshooting

### Build Fails
1. Clean build folder (⌘+Shift+K)
2. Delete derived data
3. Restart Xcode
4. Check iOS deployment target

### Runtime Crashes
1. Check console for error messages
2. Verify all files are in target
3. Check Info.plist permissions
4. Test on different simulator versions

### Performance Issues
1. Test on older devices/simulators
2. Profile with Instruments
3. Check image processing performance
4. Monitor memory usage

## 📞 Getting Help

If you encounter issues:
1. Check this guide first
2. Search Stack Overflow with [swiftui] [ios] tags
3. Consult Apple Developer Documentation
4. Ask team members for code review

Remember: Every developer starts somewhere! Building your first iOS app is a learning process, and encountering issues is completely normal.