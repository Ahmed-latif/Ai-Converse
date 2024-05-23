import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      colorScheme: isDarkTheme
          ? ColorScheme.dark(
              background: Colors.black,
              primary: Colors.grey.shade900,
              secondary: Colors.grey.shade800)
          : ColorScheme.light(
              background: Color.fromARGB(255, 255, 255, 255),
              primary: Colors.grey.shade200,
              secondary: Colors.grey.shade100,
            ),
      iconTheme: IconThemeData(
        color: isDarkTheme ? Colors.green.shade700 : Colors.red.shade500,
      ),
      checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return const Color.fromARGB(255, 165, 50, 50).withOpacity(.32);
            }
            return const Color.fromARGB(255, 247, 245, 243);
          }),
          side: BorderSide(color: isDarkTheme ? Colors.white : Colors.black)),
      appBarTheme: AppBarTheme(
          backgroundColor:
              isDarkTheme ? Colors.black : Color.fromARGB(255, 245, 245, 245),
          elevation: 8,
          iconTheme:
              IconThemeData(color: isDarkTheme ? Colors.white : Colors.black45),
          actionsIconTheme:
              IconThemeData(color: isDarkTheme ? Colors.red : Colors.black),
          titleTextStyle: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black, fontSize: 20)),
      textTheme: TextTheme(
        titleMedium: GoogleFonts.roboto(
            color: isDarkTheme ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20),
        titleSmall: GoogleFonts.roboto(
            color: Colors.red.shade500,
            fontWeight: FontWeight.w600,
            fontSize: 18),
        bodySmall: GoogleFonts.roboto(
            color: Colors.grey.shade300,
            fontWeight: FontWeight.w400,
            fontSize: 16),
        headlineMedium: GoogleFonts.roboto(
            color: isDarkTheme
                ? Color.fromARGB(255, 211, 211, 211)
                : Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.w600,
            fontSize: 16),
        headlineSmall: GoogleFonts.roboto(
            color: Colors.green.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 16),
        headlineLarge: GoogleFonts.oswald(
            color: isDarkTheme
                ? Color.fromARGB(255, 211, 211, 211)
                : const Color.fromARGB(255, 48, 48, 48),
            fontWeight: FontWeight.w800,
            fontSize: 24),
      ),
      cardColor: isDarkTheme ? Colors.green.shade500 : Colors.red.shade500,
    );
  }
}
