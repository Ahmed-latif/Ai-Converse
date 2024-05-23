import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20)),
    textTheme: TextTheme(
      titleMedium: GoogleFonts.roboto(
          color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
      titleSmall: GoogleFonts.roboto(
          color: Colors.red.shade500,
          fontWeight: FontWeight.w600,
          fontSize: 18),
      bodySmall: GoogleFonts.roboto(
          color: Colors.grey.shade300,
          fontWeight: FontWeight.w400,
          fontSize: 16),
      headlineMedium: GoogleFonts.roboto(
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.w600,
          fontSize: 16),
      headlineSmall: GoogleFonts.roboto(
          color: Colors.green.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 16),
      headlineLarge: GoogleFonts.oswald(
          color: const Color.fromARGB(255, 48, 48, 48),
          fontWeight: FontWeight.w800,
          fontSize: 24),
    ),
    brightness: Brightness.light,
    iconTheme: IconThemeData(
      color: Colors.red.shade500,
    ),
    cardTheme: CardTheme(color: const Color.fromARGB(255, 59, 59, 59)),
    cardColor: Colors.red,
    colorScheme: ColorScheme.light(
        background: Color.fromARGB(255, 255, 255, 255),
        primary: Colors.grey.shade200,
        secondary: Colors.grey.shade100,
        onBackground: Colors.black));
