# Prescription LLM

An iOS application that uses OCR and AI to analyze prescription images and provide detailed explanations through an interactive chat interface.

## Overview

This app allows users to:
- Capture prescription images using their device camera
- Extract text from prescriptions using OCR technology
- Get AI-powered explanations of medications and dosages
- Ask follow-up questions through an interactive chat interface

## Documentation

### Planning & Design
- [**Requirements**](REQUIREMENTS.md) - Detailed functional and technical requirements
- [**UI Design**](UI_DESIGN.md) - User interface specifications and user flow
- [**Architecture**](ARCHITECTURE.md) - System architecture and component design

### Implementation
- [**Project Structure**](PROJECT_STRUCTURE.md) - File organization and naming conventions
- [**API Integration**](API_INTEGRATION.md) - OCR and LLM service integration patterns
- [**Development Setup**](DEVELOPMENT_SETUP.md) - Complete setup guide for new developers

## Quick Start

### Prerequisites
- Xcode 15.0+
- iOS 15.0+ SDK
- OpenAI API key (for LLM functionality)
- Google Vision API key (optional, for cloud OCR)

### Setup
1. Clone this repository
2. Follow the [Development Setup Guide](DEVELOPMENT_SETUP.md)
3. Configure API keys in your build configuration
4. Build and run on iOS Simulator

### MVP Features
- [x] Camera interface for prescription capture
- [x] Local OCR using Apple Vision Framework
- [x] OpenAI GPT-4 integration for explanations
- [x] Interactive Q&A chat interface
- [x] SwiftUI-based user interface

## Technical Stack

- **Platform**: iOS 15.0+, iPadOS 15.0+
- **Language**: Swift 5.9
- **UI Framework**: SwiftUI
- **Architecture**: MVVM + Coordinator Pattern
- **OCR**: Apple Vision Framework (local) or Google Vision API (cloud)
- **AI**: OpenAI GPT-4 API
- **Networking**: URLSession (native) or Alamofire
- **Testing**: XCTest, XCUITest

## Project Structure

```
Prescription-LLM/
├── App/                    # App lifecycle and entry point
├── Views/                  # SwiftUI views organized by feature
├── ViewModels/            # MVVM view models
├── Models/                # Data models and API structures
├── Services/              # Business logic services
├── Network/               # API client and networking
├── Utilities/             # Extensions and helpers
└── Resources/             # Assets, localizations, etc.
```

## Key Features

### Camera Integration
- Native iOS camera interface
- Image quality validation
- Support for both printed and handwritten prescriptions

### OCR Processing
- Local processing with Apple Vision Framework (privacy-focused)
- Cloud processing with Google Vision API (higher accuracy)
- Text extraction and confidence scoring

### AI-Powered Explanations
- Detailed medication explanations
- Usage instructions and safety warnings
- Context-aware responses

### Interactive Chat
- Follow-up questions about prescriptions
- Conversation history
- Real-time AI responses

## Development Workflow

1. **UI First**: Build and test user interface with mock data
2. **Service Integration**: Add OCR and LLM API integrations
3. **Testing**: Comprehensive unit and UI testing
4. **Refinement**: Polish user experience and error handling

## Security & Privacy

- No persistent storage of prescription images
- Encrypted API communications
- User consent for image processing
- Secure API key management

## Contributing

This is a team project for iOS development learning. Follow the established patterns and conventions outlined in the documentation.

## License

Private project - All rights reserved.