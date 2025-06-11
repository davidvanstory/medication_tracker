# Complete Setup Guide for New iOS Developer (No Developer License Required)

## 🎯 What You'll Learn
This guide will get you from zero iOS knowledge to building our prescription scanner app. **No paid developer license needed** - everything runs on the free iOS Simulator.

## 📋 Before You Start

### Hardware Requirements
- **Mac computer** (MacBook, iMac, Mac Mini, Mac Studio)
  - macOS 13.0 or later
  - At least 8GB RAM (16GB recommended)
  - 50GB+ free storage for Xcode and simulators
- **No iPhone required** - we'll use the simulator

### Time Investment
- Initial setup: 2-3 hours
- Learning basics: 1-2 weeks
- Building our app: 2-4 weeks

## 🛠 Step 1: Install Development Tools

### Download Xcode (FREE)
1. Open **Mac App Store**
2. Search for "Xcode"
3. Click **Get** (it's free, ~10GB download)
4. Wait for installation (30-60 minutes)

**Alternative**: Download from [Apple Developer](https://developer.apple.com/xcode/) (Apple ID required, still free)

### Verify Installation
```bash
# Open Terminal and run:
xcode-select --version
# Should show: xcode-select version 2395 or similar
```

## 🏃‍♂️ Step 2: Your First iOS App (10-minute test)

### Create Test Project
1. Open **Xcode**
2. Click **"Create a new Xcode project"**
3. Choose **iOS** → **App**
4. Fill in:
   - Product Name: `TestApp`
   - Interface: **SwiftUI** (important!)
   - Language: **Swift**
   - Bundle Identifier: `com.yourname.testapp`
5. Click **Next** → **Create**

### Run Your First App
1. In Xcode, click the **Play button** (▶️) in top-left
2. Choose **iPhone 14 Pro** simulator
3. Wait for simulator to boot (~30 seconds)
4. You should see "Hello, world!" in the simulator

**🎉 Congratulations!** If you see the simulator with "Hello, world!", you're ready for iOS development!

## 📚 Step 3: Learn SwiftUI Basics (1-2 weeks)

### Essential SwiftUI Concepts

#### 1. Views and Modifiers
```swift
// Basic SwiftUI view
struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .font(.title)           // Modifier
            .foregroundColor(.blue) // Modifier
            .padding()             // Modifier
    }
}
```

#### 2. State Management
```swift
struct CounterView: View {
    @State private var count = 0  // State variable
    
    var body: some View {
        VStack {
            Text("Count: \(count)")
            Button("Tap me") {
                count += 1           // Updates UI automatically
            }
        }
    }
}
```

#### 3. Navigation
```swift
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Go to Detail", destination: DetailView())
            }
            .navigationTitle("Home")
        }
    }
}
```

### Learning Resources (Choose One Path)

**Option A: Apple's Official Tutorial (Recommended)**
- [SwiftUI Essentials](https://developer.apple.com/tutorials/swiftui/creating-and-combining-views)
- Free, comprehensive, step-by-step
- Time: 6-8 hours

**Option B: YouTube Crash Course**
- Search: "SwiftUI Tutorial 2024 Beginner"
- CodeWithChris or Sean Allen channels
- Time: 4-6 hours

**Option C: Practice App**
- Build a simple to-do list app
- Covers: Lists, Forms, Navigation, State
- Time: 1-2 weeks

## 🚀 Step 4: Set Up Our Prescription Scanner Project

### Clone/Download Project Files
```bash
# If using Git:
git clone [our-project-repository]
cd med-llm

# Or download files manually from our shared folder
```

### Create New Xcode Project
1. Open Xcode
2. **File** → **New** → **Project**
3. Choose **iOS** → **App**
4. Settings:
   - Product Name: `Prescription-LLM`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Use Core Data: **No**
   - Include Tests: **Yes**
   - Bundle Identifier: `com.yourname.Prescription-LLM`

### Set Up Project Structure
Follow our [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) to create folders:

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
└── Resources/
```

**In Xcode:**
1. Right-click on `Prescription-LLM` folder
2. **New Group** for each folder above
3. Create groups to match our structure

## 🔧 Step 5: Configure Simulator & Testing

### Install Multiple Simulators
1. **Xcode** → **Preferences** → **Platforms**
2. Download simulators:
   - iPhone 14 Pro (main development)
   - iPhone SE (3rd gen) (small screen testing)
   - iPad Air (5th gen) (tablet testing)

### Set Up Test Photos
Since simulator can't take real photos:
1. Download sample prescription images from our shared folder
2. In Simulator: **Device** → **Photos** → Drag images into Photos app
3. Or use **xcrun simctl addmedia** command

### Test Camera Access (Without Real Camera)
```swift
// This code will work in simulator for image selection
import PhotosUI

struct CameraView: View {
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Button("Select Image") {
                showingImagePicker = true
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}
```

## 🔑 Step 6: API Keys Setup (FREE TIER)

### OpenAI API Key (FREE $5 credit)
1. Go to [platform.openai.com](https://platform.openai.com)
2. Sign up (free account)
3. Go to **API Keys** section
4. **Create new secret key**
5. Copy the key (starts with `sk-...`)

**Cost Estimate**: $5 free credit lasts ~1000 requests

### Google Vision API (FREE tier)
1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Create account (free tier)
3. Create new project
4. Enable **Vision API**
5. Create **API Key** credential
6. Copy the key

**Cost Estimate**: 1000 free requests per month

### Store API Keys Safely
Create file `Config.xcconfig` (DO NOT commit to git):
```
OPENAI_API_KEY = sk-your-key-here
GOOGLE_VISION_API_KEY = your-google-key-here
USE_LOCAL_OCR = YES
```

## 📱 Step 7: Build Your First Feature

### Start with Static UI
Build the camera view without real functionality:

```swift
// Views/Camera/CameraView.swift
struct CameraView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Mock camera preview
                Rectangle()
                    .fill(Color.black)
                    .aspectRatio(4/3, contentMode: .fit)
                    .overlay(
                        Text("Camera Preview")
                            .foregroundColor(.white)
                    )
                
                Spacer()
                
                // Capture button
                Button(action: {
                    print("Capture tapped!")
                }) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 3)
                                .frame(width: 70, height: 70)
                        )
                }
                .padding()
            }
            .navigationTitle("Prescription Scanner")
            .background(Color.black)
        }
    }
}
```

### Test Your UI
1. Replace `ContentView.swift` with your `CameraView`
2. Click **Play** button
3. See your camera interface in simulator

## 🐛 Step 8: Common Issues & Solutions

### "Simulator Not Working"
```bash
# Reset simulator
xcrun simctl erase all
# Or: Device → Erase All Content and Settings
```

### "Build Failed"
- **Clean Build**: Product → Clean Build Folder (⌘+Shift+K)
- **Reset Packages**: File → Packages → Reset Package Caches

### "Preview Not Loading"
- Ensure `#Preview` is at bottom of file:
```swift
#Preview {
    CameraView()
}
```

### "Simulator Too Slow"
- Close other apps
- Reduce simulator to 50% size
- Use iPhone SE instead of iPhone 14 Pro

## 📊 Step 9: Track Your Progress

### Week 1 Goals
- [ ] Xcode installed and working
- [ ] Created first test app
- [ ] Completed SwiftUI tutorial
- [ ] Built basic camera UI

### Week 2 Goals
- [ ] Set up project structure
- [ ] Built all main views (static)
- [ ] Added navigation between views
- [ ] Integrated with image picker

### Week 3 Goals
- [ ] Added API integrations
- [ ] Implemented OCR functionality
- [ ] Built chat interface
- [ ] Added error handling

### Week 4 Goals
- [ ] Polish UI/UX
- [ ] Add loading states
- [ ] Comprehensive testing
- [ ] Performance optimization

## 🆘 Getting Help

### When You're Stuck
1. **Check our shared documentation**
2. **Use Xcode's built-in help**: Help → Developer Documentation
3. **Search Stack Overflow**: Tag your question with `[swiftui]` `[ios]`
4. **Apple Developer Forums**: developer.apple.com/forums
5. **Ask team member**: Share your screen and walk through the issue

### Good Questions to Ask
- "I'm trying to [specific goal] but getting [specific error]"
- "Here's my code [paste code], what am I missing?"
- "How do I [specific task] in SwiftUI?"

### Bad Questions to Ask
- "It doesn't work"
- "I'm getting an error" (without showing the error)
- "How do I build an app?" (too broad)

## 🎯 Success Metrics

### You'll Know You're Ready When:
- [ ] You can create a new Xcode project confidently
- [ ] You understand basic SwiftUI syntax
- [ ] You can build simple interfaces with buttons, text, images
- [ ] You can navigate between views
- [ ] You can handle user input and state changes
- [ ] You can run and debug in the simulator

### Red Flags (Ask for Help):
- Xcode crashes frequently
- Simulator never loads
- You can't create new projects
- Build errors you can't understand
- Completely lost after 2 weeks

## 📈 Next Steps After Setup

1. **Week 1**: Focus on SwiftUI basics and our UI design
2. **Week 2**: Build static versions of our screens
3. **Week 3**: Add API integrations and real functionality
4. **Week 4**: Polish, test, and optimize

Remember: **Everyone starts as a beginner!** The iOS community is helpful, and our project is well-documented. Take it one step at a time, and don't hesitate to ask questions.

**Most Important**: Get the basic setup working first before moving to advanced features. A working "Hello World" app is better than a broken complex app!