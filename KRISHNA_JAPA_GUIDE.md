# 🦚 Krishna Japa Counter - Complete Guide

A beautifully crafted devotional mantra counter app with offline voice recognition powered by Vosk. Track your spiritual journey with an immersive Krishna-themed experience.

## ✨ Features

### 🎨 Visual Design
- **Krishna-Centric Theme**: Deep midnight blue background with saffron gold accents
- **Animated Background**: Subtle particle effects and glowing ambiance
- **Mala Counter**: Animated bead visualization showing progress through 108 mantras
- **Devotional Typography**: Sanskrit-inspired fonts (Yatra One) paired with modern Inter

### 🎤 Voice Recognition
- **Offline Vosk Integration**: No internet required for speech recognition
- **Intelligent Pattern Matching**: Recognizes multiple mantra variations and transliterations
- **Full Maha Mantra Support**:
  - "Hare Krishna Hare Krishna Krishna Krishna Hare Hare Hare Ram Hare Ram Ram Ram Hare Hare"
- **Variant Recognition**: Handles different pronunciations (Krishna/Krsna/Krushna, Hare/Hari, Ram/Rama)

### 📊 Progress Tracking
- **Real-time Counter**: Beautiful glowing counter with pulse animations
- **Mala Progress**: Visual representation of progress through 108-bead cycles
- **Milestones**: Achievement tracking for 108, 216, 324, 540, and 1008 mantras
- **History Page**: View total mantras, completed malas, and progress statistics

### ⚙️ Settings & Customization
- **Mantra Presets**:
  - Hare Krishna Maha Mantra (full 32-syllable)
  - Hare Krishna (short form)
  - Om
  - Custom mantra support
- **Daily Goals**: Set targets for 108, 216, 324, or 1008 mantras
- **Voice Control**: Toggle voice recognition on/off

## 🏗️ Architecture

### Clean Architecture Layers
```
lib/
├── src/
│   ├── app/                    # App initialization
│   │   └── app.dart
│   ├── core/                   # Core utilities
│   │   ├── theme/
│   │   │   └── app_theme.dart  # Krishna theme configuration
│   │   └── widgets/            # Reusable widgets
│   │       ├── animated_background.dart
│   │       ├── mala_counter.dart
│   │       └── glowing_button.dart
│   └── feature/
│       └── mantra/
│           ├── bloc/           # State management
│           │   ├── mantra_cubit.dart
│           │   └── mantra_state.dart
│           ├── data/           # Data layer
│           │   ├── mantra_repository.dart
│           │   └── hive_mantra_repository.dart
│           ├── services/       # Services
│           │   ├── speech_service.dart
│           │   ├── vosk_speech_service.dart
│           │   └── hybrid_speech_service.dart
│           └── view/           # UI layer
│               ├── mantra_page.dart
│               ├── settings_page.dart
│               └── history_page.dart
```

### State Management
- **BLoC Pattern**: Using `flutter_bloc` for predictable state management
- **Cubit**: Simplified BLoC for mantra counting logic
- **Repository Pattern**: Abstracted data layer with Hive for local persistence

## 🎨 Design System

### Color Palette
```dart
Deep Midnight Blue: #0E1446  // Primary background
Saffron Gold:       #F5C542  // Primary accent
Lotus Pink:         #F7B7A3  // Secondary accent
Divine White:       #FFFBF7  // Text/foreground
Peacock Blue:       #1E3A8A  // Gradient accent
Temple Gold:        #D4AF37  // Mala counter
```

### Typography
- **Display/Headings**: Yatra One (Sanskrit-inspired)
- **Body/UI**: Inter (clean sans-serif)
- **Line Heights**: 150% for body, 120% for headings
- **Spacing**: 8px base grid system

### Animations
- **Mala Counter**: Scale pulse on increment (400ms)
- **Voice Button**: Breathing pulse when active (1500ms)
- **Background**: Slow particle drift (20s)
- **Glow Effect**: Radial pulse (3s)

## 🚀 Getting Started

### Prerequisites
```bash
Flutter SDK: >= 3.9.2
Dart SDK: >= 3.0.0
Android Studio (for Android)
Xcode (for iOS)
```

### Installation

1. **Clone and Setup**
```bash
cd /path/to/project
flutter pub get
```

2. **Download Vosk Model** (See VOSK_SETUP_REQUIREMENTS.md)
```bash
# Small model (recommended for testing)
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip -d assets/vosk_model/
```

3. **Run the App**
```bash
flutter run
```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21 (Android 5.0)
- Vosk library automatically included via Gradle
- Microphone permissions handled automatically

#### iOS
- Minimum: iOS 13.0
- Uses Apple Speech Framework (fallback)
- Microphone permissions in Info.plist

#### Web
- Speech recognition uses Web Speech API
- Requires microphone permissions in browser
- PWA support for installation

## 🎯 Usage Guide

### Basic Flow

1. **Launch App**
   - Opens to main screen with mala counter
   - Shows current mantra (default: Hare Krishna Maha Mantra)

2. **Manual Counting**
   - Tap the golden mala counter to increment
   - Use "Add" button for manual increment
   - Use "Reset" button (with confirmation) to start over

3. **Voice Recognition**
   - Tap "Start Chanting" button
   - Grant microphone permission if prompted
   - Chant your mantra clearly
   - Counter auto-increments on recognition
   - Tap "Stop Listening" when done

4. **View Progress**
   - Tap history icon (top-left) to see statistics
   - View total mantras, completed malas, and milestones
   - Track progress toward next mala (108 beads)

5. **Customize Settings**
   - Tap settings icon (top-right)
   - Select from preset mantras or add custom
   - Set daily goals
   - View app information

### Voice Recognition Tips

**For Best Results:**
- Speak clearly and at moderate pace
- Ensure quiet environment
- Hold device 6-12 inches from mouth
- Complete full mantra before pausing

**Supported Mantras:**
- Full Maha Mantra: "Hare Krishna Hare Krishna Krishna Krishna Hare Hare Hare Ram Hare Ram Ram Ram Hare Hare"
- Short form: "Hare Krishna"
- Single syllable: "Om"
- Custom mantras: Any phrase you set

**Recognition Variations:**
- Hare/Hari/Haray
- Krishna/Krsna/Krushna
- Ram/Rama/Raam
- Om/Aum/Ohm

## 🔧 Customization

### Adding New Mantras

1. **Via Settings UI**
   - Go to Settings
   - Expand "Custom Mantra"
   - Enter mantra text
   - Tap "Set Mantra"

2. **Via Code** (for presets)
```dart
// In settings_page.dart
_MantraPresetTile(
  title: 'Om Namah Shivaya',
  subtitle: 'Salutation to Shiva',
  mantra: 'om namah shivaya',
),
```

### Modifying Theme Colors

```dart
// In lib/src/core/theme/app_theme.dart
static const yourColor = Color(0xFFXXXXXX);

// Update in krishnaTheme
colorScheme: ColorScheme.dark(
  primary: yourColor,
  // ...
),
```

### Adjusting Recognition Patterns

```dart
// In lib/src/feature/mantra/bloc/mantra_cubit.dart
String _wordPattern(String word) {
  if (w == 'your_word') {
    return '(?:variant1|variant2|variant3)';
  }
  // ...
}
```

## 📱 Responsive Design

### Mobile (< 600px)
- Full-screen mala counter
- Stacked button layout
- Touch-optimized tap targets (minimum 48px)

### Tablet (600px - 1024px)
- Larger mala counter (320px)
- Side-by-side button layout
- Enhanced visual effects

### Desktop/Web (> 1024px)
- Centered layout with max-width
- Keyboard shortcuts support
- Mouse hover effects

## 🐛 Troubleshooting

### Voice Recognition Not Working

**Issue**: "Microphone permission denied"
- **Solution**: Go to device settings → App permissions → Enable microphone

**Issue**: "Vosk initialization failed"
- **Solution**: Ensure Vosk model is in `assets/vosk_model/` directory
- Check VOSK_SETUP_REQUIREMENTS.md for proper setup

**Issue**: Mantra not being recognized
- **Solution**:
  - Speak more clearly
  - Check if mantra is in supported list
  - Try manual pronunciation variants in settings

### UI Issues

**Issue**: Fonts not loading
- **Solution**: Run `flutter pub get` to fetch font assets
- Check internet connection for Google Fonts

**Issue**: Animations stuttering
- **Solution**:
  - Close background apps
  - Reduce animation duration in theme
  - Disable background particles if needed

### Build Issues

**Issue**: Android build fails
- **Solution**:
  - Update Gradle: `cd android && ./gradlew wrapper --gradle-version 7.5`
  - Clean: `flutter clean && flutter pub get`

**Issue**: iOS build fails
- **Solution**:
  - Run: `cd ios && pod install`
  - Update CocoaPods: `sudo gem install cocoapods`

## 🎭 Performance Optimization

### Reducing App Size
- Use small Vosk model (39MB vs 1.8GB)
- Enable ProGuard/R8 for Android release builds
- Use web compression for Flutter Web

### Improving Recognition Speed
- Use compressed Vosk model for balance
- Limit background animations on low-end devices
- Cache frequently used widgets

### Battery Optimization
- Stop voice recognition when app is backgrounded
- Reduce animation frame rate on battery saver mode
- Use efficient state management

## 🌐 Deployment

### Android (APK/AAB)
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS (App Store)
```bash
flutter build ios --release
```

### Web (PWA)
```bash
flutter build web --release --web-renderer canvaskit
```

## 🙏 Spiritual Context

### About Japa Meditation
Japa is the meditative practice of repeating a mantra, traditionally using a mala (prayer beads). The standard mala has 108 beads, representing various spiritual significances in Hindu tradition.

### The Hare Krishna Maha Mantra
This 32-syllable mantra is central to Gaudiya Vaishnavism:
```
Hare Krishna Hare Krishna
Krishna Krishna Hare Hare
Hare Ram Hare Ram
Ram Ram Hare Hare
```

**Meaning**: A devotional call to Krishna and Rama, forms of the Supreme.

### Traditional Practice
- Complete 1 mala (108 repetitions) as a session
- Daily goal: 16 malas (1,728 repetitions)
- Focus on pronunciation and devotion
- Use this app to maintain count without distraction

## 📚 Technical Deep Dive

### Voice Recognition Pipeline

1. **Initialization**
   - Load Vosk model from assets
   - Request microphone permissions
   - Initialize audio recorder

2. **Streaming Recognition**
   - Capture audio chunks (16kHz, mono)
   - Feed to Vosk recognizer
   - Receive partial results in real-time

3. **Pattern Matching**
   - Normalize recognized text
   - Apply regex patterns for variants
   - Count occurrences of target mantras
   - Increment counter on detection

4. **State Management**
   - Update MantraState via Cubit
   - Trigger UI animations
   - Persist count to Hive

### Data Flow
```
User Voice → Microphone → Vosk Engine → Partial Text
  → Pattern Matcher → MantraCubit → MantraState
  → UI Builder → Animated Counter → User Feedback
```

## 🤝 Contributing

This is a personal devotional project, but suggestions for improvements are welcome!

**Areas for Enhancement:**
- Additional mantra presets
- More language models
- Cloud sync capabilities
- Social sharing features
- Advanced statistics
- Guided meditation timers

## 📄 License

This project is created for devotional and educational purposes.

## 🙏 Acknowledgments

- **Vosk**: Open-source speech recognition
- **Flutter Community**: Amazing framework and packages
- **ISKCON**: Inspiration for the Hare Krishna tradition
- **Google Fonts**: Beautiful typography

## 📞 Support

For issues or questions:
1. Check VOSK_SETUP_REQUIREMENTS.md
2. Review Troubleshooting section above
3. Check Flutter/Vosk documentation

---

**May your chanting bring you peace and devotion** 🕉️ **Hare Krishna!** 🦚
