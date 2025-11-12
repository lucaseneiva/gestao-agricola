import 'package:flutter/material.dart';

const strawberryRed = Color(0xFFD32F2F);
const leafGreen = Color(0xFF388E3C);
const softWhite = Color(0xFFFDFBF8);

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: strawberryRed,
      primary: strawberryRed,
      secondary: leafGreen,
      surface: softWhite,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: softWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: strawberryRed,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: strawberryRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );
}