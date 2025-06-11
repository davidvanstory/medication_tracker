# Troubleshooting Guide

## 🚨 Common Build Errors

### Error: "Cannot find 'X' in scope"

**Examples:**
- Cannot find 'CameraView' in scope
- Cannot find 'Prescription' in scope
- Cannot find 'PrescriptionService' in scope

**Causes:**
- Missing file in Xcode target
- Typo in import statement
- File not added to project

**Solutions:**
1. Right-click file → "Add to Target" → Select your app target
2. Check spelling of class/struct names
3. Verify import statements at top of file
4. Clean build (⌘+Shift+K) and rebuild

### Error: "Use of undeclared type"

**Example:**
```
Use of undeclared type 'ProcessingState'
```

**Solution:**
Ensure all custom types are defined. Add missing enum:
```swift
enum ProcessingState {
    case idle
    case processing
    case completed
    case failed(Error)
}
```

### Error: "Missing argument label"

**Example:**
```
Missing argument label 'prescription:' in call
```

**Solution:**
Check function signatures match calls:
```swift
// Correct
ChatView(prescription: myPrescription)

// Incorrect
ChatView(myPrescription)
```

### Error: "Cannot convert value of type"

**Example:**
```
Cannot convert value of type 'String' to expected argument type 'Binding<String>'
```

**Solution:**
Use `$` for bindings:
```swift
// Correct
TextField("Text", text: $viewModel.text)

// Incorrect
TextField("Text", text: viewModel.text)
```

## 🖼️ Image & Camera Issues

### Camera Shows Black Screen in Simulator

**Issue:** Camera interface shows black screen
**Solution:** This is normal - simulators don't have cameras. Use "Gallery" button to select test images.

### Photo Picker Not Working

**Issue:** Gallery button doesn't open photo picker
**Causes:**
- Missing photo library permission
- PHPickerViewController not properly configured

**Solutions:**
1. Add to Info.plist:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Access photos to select prescription images</string>
```
2. Verify PHPickerViewController setup in ImagePicker.swift

### Images Too Large Error

**Issue:** App crashes when processing large images
**Solution:** Images are automatically resized in UIImage+Extensions.swift. If still failing:
```swift
let processedImage = originalImage.preparedForUpload(maxSizeInMB: 2.0)
```

## 🔄 State Management Issues

### UI Not Updating

**Issue:** Changes in ViewModel don't update UI
**Causes:**
- Missing @Published on properties
- ViewModel not marked as @ObservableObject
- View not using @StateObject or @ObservedObject

**Solutions:**
1. Mark properties as @Published:
```swift
@Published var isLoading = false
```

2. Mark ViewModel as ObservableObject:
```swift
class MyViewModel: ObservableObject {
    @Published var data = ""
}
```

3. Use proper property wrappers in views:
```swift
@StateObject private var viewModel = MyViewModel()
```

### Navigation Issues

**Issue:** NavigationLink not working
**Common causes:**
- Missing NavigationView wrapper
- Nested NavigationViews
- iOS 16+ navigation changes

**Solutions:**
1. Wrap root view in NavigationView:
```swift
NavigationView {
    ContentView()
}
```

2. For iOS 16+, consider NavigationStack instead

## 🌐 Network & API Issues

### API Calls Failing

**Issue:** OCR or LLM requests fail
**Debugging steps:**
1. Check internet connection
2. Verify API keys are set
3. Check API endpoint URLs
4. Review request format

**Common fixes:**
```swift
// Check API key is loaded
if APIConfiguration.shared.openAIAPIKey.isEmpty {
    print("⚠️ OpenAI API key not configured")
}

// Test with mock service first
let llmService: LLMServiceProtocol = MockLLMService()
```

### Network Timeout Errors

**Issue:** Requests timing out
**Solutions:**
1. Increase timeout in NetworkManager:
```swift
config.timeoutIntervalForRequest = 60 // 60 seconds
```

2. Add retry logic for failed requests
3. Check network connectivity before requests

## 📱 Runtime Crashes

### Fatal Error: Index out of range

**Issue:** Array access causing crash
**Common locations:**
- Accessing first element of empty array
- IndexOutOfRange in collections

**Prevention:**
```swift
// Safe array access
if !array.isEmpty {
    let first = array[0]
}

// Or use optional
let first = array.first
```

### Force unwrapping nil value

**Issue:** Crash from force unwrapping nil optionals
**Examples:**
```swift
let image = UIImage(named: "test")! // Crashes if image doesn't exist
```

**Solutions:**
```swift
// Safe unwrapping
guard let image = UIImage(named: "test") else {
    print("Image not found")
    return
}

// Or use if let
if let image = UIImage(named: "test") {
    // Use image
}
```

## 🎨 UI Layout Issues

### Views Not Appearing

**Issue:** Views render but are invisible
**Common causes:**
- Views pushed off screen
- Transparent backgrounds
- Frame size of 0

**Debugging:**
```swift
// Add colored background to see view bounds
.background(Color.red) // Temporary debugging

// Check frame
.frame(width: 100, height: 100)
.border(Color.blue) // Temporary debugging
```

### Auto Layout Conflicts

**Issue:** Layout warnings in console
**Solutions:**
1. Use SwiftUI layout modifiers consistently
2. Avoid mixing Auto Layout with SwiftUI
3. Check for conflicting frame modifiers

### Safe Area Issues

**Issue:** Content hidden behind notch/home indicator
**Solutions:**
```swift
// Respect safe area
.padding(.top, 1) // Forces safe area recognition

// Or explicitly handle safe area
.ignoresSafeArea(.container, edges: .bottom)
```

## 🔍 Performance Issues

### App Running Slowly

**Common causes:**
- Too many views in ViewBuilder
- Heavy computations on main thread
- Large images not optimized

**Solutions:**
1. Move heavy work to background:
```swift
Task {
    // Background work
    let result = await heavyOperation()
    
    await MainActor.run {
        // Update UI on main thread
        self.result = result
    }
}
```

2. Optimize images before processing
3. Use LazyVStack for long lists

### Memory Warnings

**Issue:** App using too much memory
**Solutions:**
1. Check for retain cycles in closures
2. Use weak references where appropriate:
```swift
// Weak self in closures
someAsyncOperation { [weak self] in
    self?.updateUI()
}
```

3. Release large images after processing

## 🧪 Testing Issues

### Simulator Crashes

**Issue:** iOS Simulator crashes or becomes unresponsive
**Solutions:**
1. Device → Erase All Content and Settings
2. Restart Simulator
3. Reset to factory settings
4. Try different iOS version

### Preview Crashes

**Issue:** SwiftUI previews not working
**Solutions:**
1. Check preview code for errors:
```swift
#Preview {
    CameraView()
        .preferredColorScheme(.light) // Sometimes helps
}
```

2. Clean build and restart Xcode
3. Ensure all dependencies are available in preview

## 🔧 Xcode Issues

### Build Cache Problems

**Symptoms:**
- Builds fail for no apparent reason
- Changes not reflected in app
- Weird compilation errors

**Solutions:**
1. Clean Build Folder (⌘+Shift+K)
2. Delete Derived Data:
   - Xcode → Preferences → Locations → Derived Data → Arrow button
   - Delete entire folder
3. Restart Xcode
4. Restart Mac (if all else fails)

### Code Signing Issues

**Issue:** Cannot run on device
**Solutions:**
1. Check Team in project settings
2. Ensure device is registered
3. Try automatic code signing
4. Clean and rebuild

## 📞 Getting Help

### When to Ask for Help
- Stuck for more than 30 minutes
- Error messages you don't understand
- App crashes you can't debug

### How to Ask Good Questions
1. Include exact error message
2. Show relevant code
3. Describe what you expected vs what happened
4. Mention what you already tried

### Useful Resources
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/swiftui)
- [Swift Forums](https://forums.swift.org)

## 🎯 Prevention Tips

### Best Practices
1. Build frequently (don't wait for everything to be done)
2. Test on multiple simulators
3. Use version control (Git) to save working states
4. Comment complex code
5. Follow naming conventions

### Code Quality
1. Use meaningful variable names
2. Keep functions small and focused
3. Handle error cases gracefully
4. Add print statements for debugging

Remember: Debugging is a normal part of development. Every iOS developer deals with these issues - you're not alone!