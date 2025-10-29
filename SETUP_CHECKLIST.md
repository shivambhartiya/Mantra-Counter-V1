# 🦚 Krishna Japa Setup Checklist

Follow this checklist to get your Krishna Japa app up and running!

---

## ✅ Pre-Setup Requirements

### System Check
- [ ] Flutter SDK 3.9.2+ installed (`flutter --version`)
- [ ] Dart SDK 3.0.0+ installed (comes with Flutter)
- [ ] Android Studio / Xcode installed (for mobile)
- [ ] Device/Emulator ready for testing
- [ ] Internet connection (for downloading Vosk model)

### Quick Verification
```bash
flutter doctor -v
```
Ensure all checks pass (at least 1 platform should be ready).

---

## 📦 Installation Steps

### Step 1: Get Dependencies
```bash
cd /path/to/project
flutter pub get
```

**Expected Output:**
```
Running "flutter pub get"...
Resolving dependencies...
+ flutter_bloc X.X.X
+ hive X.X.X
...
Got dependencies!
```

✅ **Check**: No error messages, all packages resolved.

---

### Step 2: Download Vosk Model ⚠️ CRITICAL

**Option A: Small Model (Recommended)**
```bash
# Download (39MB)
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip

# Create directory if needed
mkdir -p assets/vosk_model

# Extract
unzip vosk-model-small-en-us-0.15.zip -d assets/vosk_model/

# Flatten directory structure
mv assets/vosk_model/vosk-model-small-en-us-0.15/* assets/vosk_model/
rmdir assets/vosk_model/vosk-model-small-en-us-0.15

# Cleanup
rm vosk-model-small-en-us-0.15.zip
```

**Option B: Manual Download**
1. Visit: https://alphacephei.com/vosk/models
2. Download: `vosk-model-small-en-us-0.15.zip`
3. Extract to: `assets/vosk_model/`
4. Ensure structure:
   ```
   assets/
     vosk_model/
       am/
       conf/
       graph/
       ivector/
       README
   ```

✅ **Verify**: `ls assets/vosk_model/` shows model files (am/, conf/, graph/, etc.)

---

### Step 3: Verify Assets

Check `pubspec.yaml` includes:
```yaml
flutter:
  assets:
    - assets/vosk_model/
```

✅ **Check**: Asset path is listed in pubspec.yaml

---

### Step 4: Platform-Specific Setup

#### Android
```bash
cd android
./gradlew clean
cd ..
```

**Verify AndroidManifest.xml has permissions:**
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
```

✅ **Check**: Permissions present in `android/app/src/main/AndroidManifest.xml`

#### iOS
```bash
cd ios
pod install
cd ..
```

**Verify Info.plist has keys:**
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for voice recognition</string>
```

✅ **Check**: Permission key present in `ios/Runner/Info.plist`

---

### Step 5: Run the App

```bash
# Start with hot reload
flutter run

# Or specific device
flutter run -d <device-id>

# List devices
flutter devices
```

**Expected Output:**
```
Launching lib/main.dart on <device> in debug mode...
✓ Built build/app/outputs/flutter-apk/app-debug.apk
Installing...
Syncing files to device...
```

✅ **Check**: App launches successfully, no errors in console

---

## 🧪 Testing After Launch

### Basic Functionality Tests

#### 1. Visual Check
- [ ] App opens with Krishna-themed blue background
- [ ] Golden mala counter visible in center
- [ ] Current mantra displayed at top
- [ ] "Start Chanting" button at bottom
- [ ] App bar shows 🦚 Krishna Japa title

#### 2. Manual Counting
- [ ] Tap mala counter → count increments
- [ ] Tap "Add" button → count increments
- [ ] Counter animates (pulse effect) on increment
- [ ] Mala beads update around circle
- [ ] Tap "Reset" → shows confirmation dialog
- [ ] Confirm reset → count returns to 0

#### 3. Voice Recognition
- [ ] Tap "Start Chanting" → button turns red
- [ ] Permission prompt appears (first time)
- [ ] Grant permission → button shows "Stop Listening"
- [ ] Chant mantra clearly → counter increments
- [ ] Recognition works for "Hare Krishna"
- [ ] Tap "Stop Listening" → returns to normal

#### 4. Navigation
- [ ] Tap history icon (top-left) → opens History page
- [ ] History shows total count, malas, progress
- [ ] Back button returns to main screen
- [ ] Tap settings icon (top-right) → opens Settings
- [ ] Settings shows mantra presets
- [ ] Back button returns to main screen

#### 5. Settings Features
- [ ] Tap "Hare Krishna Maha Mantra" preset → selected
- [ ] Return to main → mantra updated in display
- [ ] Tap "Om" preset → switches mantra
- [ ] Expand "Custom Mantra" → input field appears
- [ ] Enter custom text → "Set Mantra" button enabled
- [ ] Set custom → returns to main with new mantra

#### 6. Animations
- [ ] Background has subtle particle effects
- [ ] Counter glows when incremented
- [ ] Voice button pulses when active
- [ ] Smooth transitions between pages
- [ ] No jank or stuttering (60fps)

---

## 🐛 Troubleshooting

### Issue: "Vosk model not found"
**Solution:**
1. Verify `assets/vosk_model/` exists and contains model files
2. Run `flutter clean && flutter pub get`
3. Rebuild app

### Issue: "Permission denied" for microphone
**Solution:**
1. Go to device Settings → Apps → Krishna Japa → Permissions
2. Enable Microphone permission
3. Restart app

### Issue: App won't build (Android)
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: App won't build (iOS)
**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: Fonts not loading
**Solution:**
1. Check internet connection (fonts load from Google)
2. Or download fonts locally and update pubspec.yaml
3. Run `flutter clean && flutter pub get`

### Issue: Counter not incrementing with voice
**Solution:**
1. Speak clearly and at moderate pace
2. Ensure quiet environment
3. Try different mantra (start with "Om")
4. Check microphone works in other apps
5. Review logs: `flutter run -v`

---

## 📊 Success Indicators

✅ **App launches without errors**
✅ **Krishna theme visible (blue + gold)**
✅ **Mala counter shows and increments**
✅ **Voice recognition works (at least for simple mantras)**
✅ **Navigation works (History, Settings)**
✅ **Animations are smooth (no lag)**
✅ **Data persists (count survives app restart)**

---

## 🎯 Next Steps After Setup

1. **Familiarize yourself with the app**
   - Read KRISHNA_JAPA_GUIDE.md
   - Try all features
   - Test voice recognition with different mantras

2. **Customize to your preference**
   - Set your preferred mantra in Settings
   - Choose a daily goal
   - Explore milestone achievements

3. **Start your devotional practice**
   - Begin with small session (1 mala = 108 mantras)
   - Use voice recognition or manual counting
   - Track progress in History page

4. **Share feedback**
   - Note any issues or suggestions
   - Test on different devices
   - Report bugs or UX improvements

---

## 📚 Additional Resources

- **[README.md](README.md)** - Quick overview and features
- **[KRISHNA_JAPA_GUIDE.md](KRISHNA_JAPA_GUIDE.md)** - Complete usage guide
- **[VOSK_SETUP_REQUIREMENTS.md](VOSK_SETUP_REQUIREMENTS.md)** - Detailed Vosk docs
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Technical details

---

## 🙏 Ready to Begin?

Once all checkboxes are complete and tests pass, you're ready to start your devotional practice!

**Hare Krishna!** 🕉️🦚

---

**Need Help?**
- Check Troubleshooting section above
- Review documentation files
- Verify all checklist items completed
- Check Flutter/Vosk logs for errors
