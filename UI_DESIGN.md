# UI Design & User Flow

## User Flow
```
Launch App → Camera View → Capture Image → Processing → Results → Q&A Chat
```

## Screen Designs

### 1. Home/Camera Screen
**Purpose**: Primary entry point for capturing prescriptions

**Layout**:
- Full-screen camera preview
- Capture button (large, centered at bottom)
- Flash toggle (top-left)
- Settings/help icon (top-right)
- Guidance overlay: "Position prescription within frame"

**UI Elements**:
- Navigation bar: title "Prescription Scanner"
- Camera viewfinder with prescription frame guide
- Capture button: Large circular button with camera icon
- Secondary button: "Choose from Photos" (smaller, below capture)

### 2. Image Preview Screen
**Purpose**: Confirm captured image before processing

**Layout**:
- Full-screen image preview
- Bottom toolbar with actions
- "Retake" and "Analyze" buttons

**UI Elements**:
- Navigation: Back arrow, "Preview" title
- Image view: Full-screen captured image
- Action buttons: "Retake" (secondary), "Analyze Prescription" (primary)

### 3. Processing Screen
**Purpose**: Show progress while analyzing prescription

**Layout**:
- Centered loading indicator
- Progress text
- Thumbnail of captured image

**UI Elements**:
- Progress indicator: Animated spinner
- Status text: "Analyzing prescription..." / "Generating explanation..."
- Cancel button (if needed)

### 4. Results Screen
**Purpose**: Display prescription analysis and explanation

**Layout**:
- Scrollable content area
- Fixed bottom bar with chat button
- Card-based information display

**UI Elements**:
- Navigation: Back arrow, "Results" title
- Prescription image thumbnail (tappable for full view)
- Extracted text section
- AI explanation section (formatted nicely)
- "Ask Questions" button (prominent, bottom)

**Content Sections**:
1. **Extracted Information**
   - Medication name(s)
   - Dosage and frequency
   - Doctor/pharmacy info
   
2. **AI Explanation**
   - What this medication is for
   - How to take it
   - Important notes/warnings

### 5. Chat/Q&A Screen
**Purpose**: Interactive conversation about prescription

**Layout**:
- Chat interface with message bubbles
- Text input at bottom
- Conversation history

**UI Elements**:
- Navigation: Back arrow, "Ask Questions" title
- Message list: User and AI messages
- Input field: Text field with send button
- Quick suggestion buttons (optional)

**Message Types**:
- User messages: Right-aligned, blue bubbles
- AI responses: Left-aligned, gray bubbles
- System messages: Centered, smaller text

## Design System

### Colors
- Primary: #007AFF (iOS blue)
- Secondary: #34C759 (iOS green)
- Background: #F2F2F7 (iOS light gray)
- Text: #000000 (primary), #8E8E93 (secondary)
- Error: #FF3B30 (iOS red)

### Typography
- Large Title: SF Pro Display, 34pt, Bold
- Title 1: SF Pro Display, 28pt, Bold
- Headline: SF Pro Text, 17pt, Semibold
- Body: SF Pro Text, 17pt, Regular
- Caption: SF Pro Text, 12pt, Regular

### Components
- Buttons: Rounded corners (8pt), minimum height 44pt
- Cards: White background, 12pt corner radius, subtle shadow
- Input fields: Rounded corners (8pt), border on focus

## Accessibility
- VoiceOver support for all interactive elements
- Minimum 44pt touch targets
- High contrast support
- Dynamic Type support
- Haptic feedback for key interactions

## Navigation Patterns
- Standard iOS navigation controller
- Modal presentation for camera interface
- Tab bar for future multi-section app
- Swipe gestures for navigation where appropriate