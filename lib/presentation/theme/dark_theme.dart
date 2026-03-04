import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF0A84FF), // Softer blue for dark mode
    surface: Color(0xFF1E1E1E), // Slightly lighter than background
    error: Color(0xFFFF453A),
    onSurface: Color(0xFFFFFFFF),
    onSurfaceVariant: Color(0xFFAAAAAA),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0xFF0A84FF)),
    titleTextStyle: TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: '.SF Pro Text', // Native iOS feel
    ),
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(color: Color(0xFFFFFFFF), fontSize: 17),
    bodyMedium: TextStyle(color: Color(0xFFAAAAAA), fontSize: 15),
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF1E1E1E),
    elevation: 2, // Slight elevation in dark mode to differentiate components
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF0A84FF),
    foregroundColor: Colors.white,
    shape: CircleBorder(),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E1E1E),
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
      borderSide: const BorderSide(color: Color(0xFF0A84FF)),
    ),
    hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
);
