import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey.shade600,
    secondary: const Color.fromARGB(255, 49, 49, 49),
    surface: Colors.grey.shade900,
    tertiary: Colors.grey.shade800,
    inversePrimary: Colors.grey.shade400,
  ),
);