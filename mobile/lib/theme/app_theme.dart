import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Institutional Academic Minimalism Palette (Sama dengan Web)
  static const Color bgCanvas = Color(0xFFFBFBFA);
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE4E4E7);
  static const Color borderStrong = Color(0xFFD4D4D8);

  static const Color textPrimary = Color(0xFF18181B);
  static const Color textSecondary = Color(0xFF52525B);
  static const Color textTertiary = Color(0xFF71717A);

  static const Color navy900 = Color(0xFF0F172A);
  static const Color untidarBlue = Color(0xFF1E3A8A);

  static const Color sealGreen = Color(0xFF15803d);
  static const Color sealGreenBg = Color(0xFFF0FDF4);
  static const Color sealGreenBorder = Color(0xFFBBF7D0);

  static const Color sealAmber = Color(0xFFB45309);
  static const Color sealAmberBg = Color(0xFFFEFCE8);
  static const Color sealAmberBorder = Color(0xFFCA8A04);

  static const Color sealRed = Color(0xFFB91C1C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgCanvas,
      colorScheme: const ColorScheme.light(
        primary: navy900,
        secondary: untidarBlue,
        surface: bgSurface,
        error: sealRed,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: navy900,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          color: textPrimary,
          height: 1.4,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textTertiary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: navy900,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: bgSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: borderLight, width: 1),
        ),
        margin: const EdgeInsets.only(bottom: 12),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgSurface,
        selectedItemColor: untidarBlue,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        elevation: 4,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
