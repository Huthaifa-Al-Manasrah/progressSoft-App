import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF003366);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      primarySwatch: MaterialColor(
        primaryColor.value,
        {
          50: primaryColor.withOpacity(.1),
          100: primaryColor.withOpacity(.2),
          200: primaryColor.withOpacity(.3),
          300: primaryColor.withOpacity(.4),
          400: primaryColor.withOpacity(.5),
          500: primaryColor.withOpacity(.6),
          600: primaryColor.withOpacity(.7),
          700: primaryColor.withOpacity(.8),
          800: primaryColor.withOpacity(.9),
          900: primaryColor,
        },
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'open Sans',
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: primaryColor
        )
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
          textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
