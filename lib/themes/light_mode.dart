import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    surface: Colors.grey.shade300,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade300,
  ),
);
