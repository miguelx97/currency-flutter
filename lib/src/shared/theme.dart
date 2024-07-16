import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData().copyWith(
  primaryColor: const Color(0xff87C7EB),
  primaryColorDark: const Color(0xff2291d0),
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xFFE7ECEF),
    tertiary: Color(0xff436375),
    surface: Colors.white,
    surfaceVariant: Colors.black38,
    primary: Color(0xff87C7EB),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: const Color(0xff6c9fbc),
  primaryColorDark: const Color(0xff176591),
  brightness: Brightness.dark,

  colorScheme: const ColorScheme.dark(
    background: Color(0xFF2b2f31),
    tertiary: Color(0xffeceff1),
    surface: Colors.white12,
    surfaceVariant: Colors.black54,
    primary: Color(0xff6c9fbc)
  ),
);
