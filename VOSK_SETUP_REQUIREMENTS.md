# Vosk Speech Recognition Setup Requirements

This document outlines all the requirements and steps needed to implement Vosk speech recognition in your Flutter application.

## 📋 Prerequisites

### System Requirements
- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **Android Studio**: Latest version with Android SDK
- **Xcode**: Latest version (for iOS development)
- **Python**: 3.5 or higher (for model preparation, optional)

### Platform Requirements
- **Android**: API level 21 (Android 5.0) or higher
- **iOS**: iOS 13.0 or higher
- **Storage**: At least 200MB free space for model files

## 🔧 Installation Steps

### 1. Install Flutter Dependencies

Run the following command to install the required packages:

```bash
flutter pub get
```

The following packages have been added to your `pubspec.yaml`:
- `permission_handler: ^11.0.1` - For handling microphone permissions
- `path_provider: ^2.1.1` - For accessing device storage

### 2. Download Vosk Model

#### Option A: Small Model (Recommended for testing)
```bash
# Download the small English model (39 MB)
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip

# Extract to assets directory
unzip vosk-model-small-en-us-0.15.zip -d assets/vosk_model/
mv assets/vosk_model/vosk-model-small-en-us-0.15/* assets/vosk_model/
rmdir assets/vosk_model/vosk-model-small-en-us-0.15
```

#### Option B: Full Model (Better accuracy)
```bash
# Download the full English model (1.8 GB)
wget https://alphacephei.com/vosk/models/vosk-model-en-us-0.22.zip

# Extract to assets directory
unzip vosk-model-en-us-0.22.zip -d assets/vosk_model/
mv assets/vosk_model/vosk-model-en-us-0.22/* assets/vosk_model/
rmdir assets/vosk_model/vosk-model-en-us-0.22
```

#### Option C: Compressed Model (Balance of size and accuracy)
```bash
# Download the compressed model (128 MB)
wget https://alphacephei.com/vosk/models/vosk-model-en-us-0.22-lgraph.zip

# Extract to assets directory
unzip vosk-model-en-us-0.22-lgraph.zip -d assets/vosk_model/
mv assets/vosk_model/vosk-model-en-us-0.22-lgraph/* assets/vosk_model/
rmdir assets/vosk_model/vosk-model-en-us-0.22-lgraph
```

### 3. Android Setup

#### Gradle Configuration
The following dependencies have been added to your `android/app/build.gradle.kts`:
```kotlin
dependencies {
    implementation 'com.alphacephei:vosk-android:0.3.45'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.6.4'
}
```

#### Permissions
The following permissions have been added to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

#### Native Implementation
- `VoskMethodCallHandler.kt` - Handles Vosk initialization and speech recognition
- `MainActivity.kt` - Updated to register the Vosk method channel

### 4. iOS Setup

#### Permissions
The following permissions have been added to `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to microphone for speech recognition.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs access to speech recognition for voice commands.</string>
```

#### Native Implementation
- `VoskMethodCallHandler.swift` - Handles speech recognition using iOS Speech framework
- `AppDelegate.swift` - Updated to register the Vosk method channel

**Note**: The iOS implementation uses Apple's Speech framework as Vosk doesn't have native iOS support. This provides similar functionality with Apple's built-in speech recognition.

### 5. Flutter Code Updates

#### New Files Created:
- `lib/src/feature/mantra/services/vosk_speech_service.dart` - Main Vosk service interface
- `assets/vosk_model/README.md` - Model setup instructions

#### Updated Files:
- `lib/main.dart` - Updated to use VoskSpeechService
- `lib/src/feature/mantra/bloc/mantra_cubit.dart` - Updated to use new Vosk API
- `pubspec.yaml` - Added dependencies and assets

## 🚀 Running the Application

### 1. Clean and Rebuild
```bash
flutter clean
flutter pub get
```

### 2. Run on Android
```bash
flutter run
```

### 3. Run on iOS
```bash
flutter run
```

## 🔍 Troubleshooting

### Common Issues

#### 1. Model Not Found Error
**Problem**: "Model path does not exist"
**Solution**: Ensure you've downloaded and extracted the Vosk model to `assets/vosk_model/`

#### 2. Permission Denied
**Problem**: Microphone permission denied
**Solution**: 
- Check device settings for microphone permissions
- Ensure permissions are properly declared in manifest files

#### 3. Build Errors on Android
**Problem**: Gradle build fails
**Solution**:
- Ensure you're using the correct Kotlin version
- Clean and rebuild the project
- Check that all dependencies are properly added

#### 4. iOS Speech Recognition Not Working
**Problem**: Speech recognition fails on iOS
**Solution**:
- Ensure device has internet connection (for Apple's speech recognition)
- Check that iOS version is 13.0 or higher
- Verify microphone permissions are granted

### Performance Optimization

#### Model Size Considerations
- **Small Model (39 MB)**: Good for basic recognition, faster loading
- **Full Model (1.8 GB)**: Better accuracy, slower loading, more storage required
- **Compressed Model (128 MB)**: Balance between size and accuracy

#### Memory Usage
- Vosk models are loaded into memory during initialization
- Consider using the smaller model for devices with limited RAM
- The model is unloaded when the app is backgrounded

## 📚 Additional Resources

- [Vosk Official Documentation](https://alphacephei.com/vosk/)
- [Vosk Models Repository](https://alphacephei.com/vosk/models)
- [Flutter Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [Android Audio Recording](https://developer.android.com/guide/topics/media/mediarecorder)
- [iOS Speech Framework](https://developer.apple.com/documentation/speech)

## 🔄 Migration from speech_to_text

The implementation maintains the same interface as your original `SpeechService`, so the migration is seamless:

1. ✅ Same method signatures (`initialize`, `start`, `stop`)
2. ✅ Same callback structure (`onPartial`, `onComplete`, `onError`)
3. ✅ Same permission handling
4. ✅ Same state management in `MantraCubit`

The only difference is the improved accuracy and offline capability of Vosk compared to the basic `speech_to_text` package.

## 📝 Notes

- **Offline Capability**: Vosk works entirely offline once the model is downloaded
- **Language Support**: Currently configured for English (en-US). Other languages require different models
- **Accuracy**: Vosk typically provides better accuracy than basic speech recognition packages
- **Privacy**: All processing is done locally on the device
- **Battery**: Continuous listening may impact battery life on mobile devices
