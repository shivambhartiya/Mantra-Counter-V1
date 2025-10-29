import 'package:flutter/material.dart';

class AppTheme {
  static const deepMidnightBlue = Color(0xFF0E1446);
  static const saffronGold = Color(0xFFF5C542);
  static const lotusPink = Color(0xFFF7B7A3);
  static const divineWhite = Color(0xFFFFFBF7);
  static const sacredOrange = Color(0xFFFF8933);
  static const templeGold = Color(0xFFD4AF37);
  static const peacockBlue = Color(0xFF1E3A8A);
  static const krishnaBlue = Color(0xFF4F46E5);

  static const radialGradient = RadialGradient(
    center: Alignment.center,
    radius: 1.5,
    colors: [
      Color(0xFF1E3A8A),
      Color(0xFF0E1446),
    ],
  );

  static ThemeData krishnaTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: deepMidnightBlue,
    primaryColor: saffronGold,
    colorScheme: ColorScheme.dark(
      primary: saffronGold,
      secondary: lotusPink,
      surface: deepMidnightBlue,
      onSurface: divineWhite,
      error: sacredOrange,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'YatraOne',
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: saffronGold,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontFamily: 'YatraOne',
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: divineWhite,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        fontFamily: 'YatraOne',
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: divineWhite,
        letterSpacing: 0.3,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'YatraOne',
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: saffronGold,
        letterSpacing: 0.3,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: divineWhite,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: divineWhite.withOpacity(0.9),
        letterSpacing: 0.15,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: divineWhite.withOpacity(0.87),
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: divineWhite.withOpacity(0.8),
        letterSpacing: 0.25,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: divineWhite,
        letterSpacing: 0.1,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: divineWhite,
      titleTextStyle: TextStyle(
        fontFamily: 'YatraOne',
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: divineWhite,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: deepMidnightBlue.withOpacity(0.6),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: saffronGold,
        foregroundColor: deepMidnightBlue,
        elevation: 8,
        shadowColor: saffronGold.withOpacity(0.5),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: saffronGold,
      size: 24,
    ),
  );

  static ThemeData get lightTheme => krishnaTheme.copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: divineWhite,
    colorScheme: ColorScheme.light(
      primary: saffronGold,
      secondary: lotusPink,
      surface: divineWhite,
      onSurface: deepMidnightBlue,
      error: sacredOrange,
    ),
  );
}
