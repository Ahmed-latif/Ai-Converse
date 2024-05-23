import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      background: Colors.black,
      primary: Colors.grey.shade900,
      secondary: Colors.grey.shade800),
  primaryColor: Colors.grey[900],
  iconTheme: IconThemeData(color: Colors.green.shade200),
  primaryIconTheme: IconThemeData(color: Colors.grey),
  textTheme: TextTheme(
    titleMedium: GoogleFonts.roboto(
        color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
    titleSmall: GoogleFonts.roboto(
        color: Colors.red.shade500, fontWeight: FontWeight.w600, fontSize: 18),
    headlineLarge: GoogleFonts.oswald(
        color: Color.fromARGB(255, 211, 211, 211),
        fontWeight: FontWeight.w800,
        fontSize: 24),
    headlineMedium: GoogleFonts.roboto(
        color: Color.fromARGB(255, 211, 211, 211),
        fontWeight: FontWeight.w600,
        fontSize: 16),
    headlineSmall: GoogleFonts.roboto(
        color: Colors.green.shade700,
        fontWeight: FontWeight.w600,
        fontSize: 16),
  ),
);
