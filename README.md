# 🦚 Krishna Japa Counter

A beautifully crafted devotional mantra counter app with offline voice recognition. Track your spiritual journey with an immersive Krishna-themed experience powered by Vosk speech recognition.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey)

---

## ✨ Features

### 🎨 Devotional Design
- **Krishna-Centric Theme**: Midnight blue with saffron gold accents
- **Animated Background**: Particle effects and glowing ambiance
- **Mala Counter**: Beautiful 108-bead visualization
- **Sanskrit Typography**: Yatra One + Inter fonts

### 🎤 Smart Voice Recognition
- **Offline Vosk Engine**: No internet required
- **Full Maha Mantra Support**: 32-syllable recognition
- **Intelligent Variants**: Handles Krishna/Krsna, Hare/Hari, Ram/Rama
- **Real-time Counting**: Auto-increment on mantra detection

### 📊 Progress Tracking
- **Live Counter**: Animated mala bead progress
- **Statistics**: Total mantras, completed malas, milestones
- **History Page**: View your devotional journey
- **Daily Goals**: Set targets (108, 216, 324, 1008)

---

## 🚀 Quick Start

### Prerequisites
```bash
Flutter SDK >= 3.9.2
Dart SDK >= 3.0.0
```

### Installation

1. **Clone & Setup**
```bash
git clone <your-repo>
cd project
flutter pub get
```

2. **Download Vosk Model** ⚠️ REQUIRED
```bash
# Small English model (39MB - recommended)
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip

# Extract to assets/vosk_model/
unzip vosk-model-small-en-us-0.15.zip -d assets/vosk_model/
mv assets/vosk_model/vosk-model-small-en-us-0.15/* assets/vosk_model/
rmdir assets/vosk_model/vosk-model-small-en-us-0.15
```

3. **Run the App**
```bash
flutter run
```

---

## 📱 Supported Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| Android  | ✅ Full Support | Min SDK 21, Vosk native |
| iOS      | ✅ Full Support | iOS 13+, Apple Speech fallback |
| Web      | ⚠️ Partial | Uses Web Speech API |
| Windows  | 🔄 Coming Soon | |
| macOS    | 🔄 Coming Soon | |
| Linux    | 🔄 Coming Soon | |

---

## 📖 Documentation

- **[KRISHNA_JAPA_GUIDE.md](KRISHNA_JAPA_GUIDE.md)** - Complete usage guide, customization, and spiritual context
- **[VOSK_SETUP_REQUIREMENTS.md](VOSK_SETUP_REQUIREMENTS.md)** - Detailed Vosk model setup and troubleshooting

---

## 🎯 Usage

### Manual Counting
1. Tap the golden mala counter to increment
2. Use "Add" button for manual +1
3. Use "Reset" to start over (with confirmation)

### Voice Recognition
1. Tap "Start Chanting" button
2. Grant microphone permission
3. Chant your mantra clearly
4. Counter auto-increments on recognition
5. Tap "Stop Listening" when done

### Settings
- Select preset mantras (Hare Krishna, Om)
- Add custom mantras
- Set daily goals
- View app information

---

## 🏗️ Architecture

```
lib/
├── src/
│   ├── core/              # Theme, widgets, utilities
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   └── widgets/
│   │       ├── animated_background.dart
│   │       ├── mala_counter.dart
│   │       └── glowing_button.dart
│   └── feature/
│       └── mantra/
│           ├── bloc/      # State management (BLoC)
│           ├── data/      # Repository pattern
│           ├── services/  # Vosk speech service
│           └── view/      # UI pages
```

**Patterns Used:**
- Clean Architecture
- BLoC for state management
- Repository pattern for data
- Dependency injection via BlocProvider

---

## 🎨 Design System

### Colors
```dart
Deep Midnight Blue: #0E1446  // Background
Saffron Gold:       #F5C542  // Primary accent
Lotus Pink:         #F7B7A3  // Secondary
Divine White:       #FFFBF7  // Text
```

### Typography
- **Headings**: Yatra One (Sanskrit-inspired)
- **Body**: Inter (clean sans-serif)
- **Spacing**: 8px grid system

---

## 🔧 Customization

### Add New Mantras
```dart
// In settings_page.dart
_MantraPresetTile(
  title: 'Your Mantra',
  subtitle: 'Description',
  mantra: 'your mantra text',
),
```

### Modify Theme
```dart
// In app_theme.dart
static const yourColor = Color(0xFFXXXXXX);
```

### Adjust Recognition
```dart
// In mantra_cubit.dart
String _wordPattern(String word) {
  if (w == 'variant1' || w == 'variant2') {
    return '(?:variant1|variant2)';
  }
}
```

---

## 🐛 Troubleshooting

### Voice Recognition Issues
- **Permission denied**: Enable microphone in device settings
- **Model not found**: Follow Vosk setup in VOSK_SETUP_REQUIREMENTS.md
- **Not recognizing**: Speak clearly, check quiet environment

### Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Android specific
cd android && ./gradlew clean

# iOS specific
cd ios && pod install
```

---

## 📊 Performance

- **App Size**: ~50MB (with small Vosk model)
- **Memory**: ~100MB runtime
- **Battery**: Optimized (recognition stops when backgrounded)
- **Recognition Speed**: Real-time (<100ms latency)

---

## 🙏 Spiritual Context

### About Japa
Japa is the meditative practice of repeating a mantra using a mala (108 beads). This app helps maintain count during your devotional practice.

### Hare Krishna Maha Mantra
```
Hare Krishna Hare Krishna
Krishna Krishna Hare Hare
Hare Ram Hare Ram
Ram Ram Hare Hare
```
A 32-syllable devotional mantra central to Gaudiya Vaishnavism.

---

## 🛣️ Roadmap

- [x] Core mantra counting
- [x] Voice recognition (Vosk)
- [x] Beautiful Krishna theme
- [x] Mala bead visualization
- [x] History & statistics
- [x] Settings customization
- [ ] Cloud sync (Supabase)
- [ ] Multiple language models
- [ ] Guided meditation timer
- [ ] Social sharing
- [ ] Widget support
- [ ] Dark/Light theme toggle

---

## 🤝 Contributing

This is a devotional project created with love. Suggestions welcome!

**Areas for Enhancement:**
- More mantra presets
- Additional languages
- Advanced statistics
- Community features

---

## 📄 License

Created for devotional and educational purposes.

---

## 🙏 Acknowledgments

- **Vosk** - Open-source speech recognition
- **Flutter** - Beautiful cross-platform framework
- **ISKCON** - Inspiration for Hare Krishna tradition
- **Google Fonts** - Typography

---

## 📞 Support

- Check [KRISHNA_JAPA_GUIDE.md](KRISHNA_JAPA_GUIDE.md) for detailed help
- Review [VOSK_SETUP_REQUIREMENTS.md](VOSK_SETUP_REQUIREMENTS.md) for technical setup
- See Troubleshooting section above

---

**Hare Krishna! May your chanting bring peace and devotion** 🕉️🦚

---

## 🖼️ Screenshots

### Main Counter Screen
- Animated mala bead counter with golden glow
- Current mantra display with devotional styling
- Voice recognition button with pulse animation

### History & Statistics
- Total mantras counted
- Completed malas (108-count cycles)
- Progress toward next mala
- Milestone achievements

### Settings Page
- Preset mantra selection
- Custom mantra input
- Daily goal setting
- App information

---

**Built with devotion using Flutter** 💙
