import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const seedColor = Color(0xFF753188);
const appBarColor = Colors.deepPurple;
const scaffoldBackgroundColor = Color(0xFF2C272E);

class AppTheme {
  ThemeData getTheme() => ThemeData(
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    brightness: Brightness.dark,
    colorSchemeSeed: seedColor,
    textTheme: GoogleFonts.emilysCandyTextTheme(ThemeData.dark().textTheme),
  );
}
