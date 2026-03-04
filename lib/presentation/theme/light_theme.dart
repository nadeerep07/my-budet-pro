import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF2F2F7),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF007AFF),
    surface: Color(0xFFFFFFFF),
    error: Color(0xFFFF3B30),
    onSurface: Color(0xFF1C1C1E),
    onSurfaceVariant: Color(0xFF8E8E93),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF2F2F7),
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0xFF007AFF)),
    titleTextStyle: TextStyle(
      color: Color(0xFF1C1C1E),
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: '.SF Pro Text', // Native iOS feel
    ),
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      color: Color(0xFF1C1C1E),
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: Color(0xFF1C1C1E),
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(color: Color(0xFF1C1C1E), fontSize: 17),
    bodyMedium: TextStyle(color: Color(0xFF8E8E93), fontSize: 15),
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFFFFFFFF),
    elevation: 0, // Using IOSCard instead for shadows
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF007AFF),
    foregroundColor: Colors.white,
    shape: CircleBorder(),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFFFFFFF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF007AFF)),
    ),
    hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
);
