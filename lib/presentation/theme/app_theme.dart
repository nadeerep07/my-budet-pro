import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF007AFF);
  static const Color backgroundWhite = Color(0xFFF2F2F7);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF1C1C1E);
  static const Color textGray = Color(0xFF8E8E93);
  static const Color successGreen = Color(0xFF34C759);
  static const Color errorRed = Color(0xFFFF3B30);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundWhite,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        surface: surfaceWhite,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryBlue),
        titleTextStyle: TextStyle(
          color: textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: '.SF Pro Text', // Native iOS feel
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: textBlack, fontSize: 32, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textBlack, fontSize: 22, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textBlack, fontSize: 17),
        bodyMedium: TextStyle(color: textGray, fontSize: 15),
      ),
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
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
          borderSide: const BorderSide(color: primaryBlue),
        ),
        hintStyle: const TextStyle(color: textGray),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

// iOS style container
class IOSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const IOSCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
