import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const seedColor = Colors.purple;
const appBarColor = Colors.deepPurple;

class AppTheme {
  ThemeData getTheme() => ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: seedColor,
    textTheme: _buildWhiteEmilysCandyTextTheme(),
  );
}

TextTheme _buildWhiteEmilysCandyTextTheme() {
    final baseStyle = GoogleFonts.emilysCandy();

    // Color fijo: BLANCO para todos los textos
    const Color whiteText = Colors.white;

    return TextTheme(
      displayLarge: baseStyle.copyWith(fontSize: 57, color: whiteText),
      displayMedium: baseStyle.copyWith(fontSize: 45, color: whiteText),
      displaySmall: baseStyle.copyWith(fontSize: 36, color: whiteText),
      headlineLarge: baseStyle.copyWith(fontSize: 32, color: whiteText),
      headlineMedium: baseStyle.copyWith(fontSize: 28, color: whiteText),
      headlineSmall: baseStyle.copyWith(fontSize: 24, color: whiteText),
      titleLarge: baseStyle.copyWith(fontSize: 22, color: whiteText),
      titleMedium: baseStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: whiteText),
      titleSmall: baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: whiteText),
      bodyLarge: baseStyle.copyWith(fontSize: 16, color: whiteText),
      bodyMedium: baseStyle.copyWith(fontSize: 14, color: whiteText),
      bodySmall: baseStyle.copyWith(fontSize: 12, color: whiteText),
      labelLarge: baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: whiteText),
      labelMedium: baseStyle.copyWith(fontSize: 12, color: whiteText),
      labelSmall: baseStyle.copyWith(fontSize: 11, color: whiteText),
    );
  }