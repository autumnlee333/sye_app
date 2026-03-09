import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.lightGreen[700]!, // Olive green
    onPrimary: Colors.white,
    secondary: Colors.brown[200]!, // Tan as secondary
    onSecondary: Colors.black,
    surface: Colors.brown[50]!, // Tan as surface
    onSurface: Colors.black,
    background: Colors.brown[50]!, // Tan as background
    onBackground: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.lightGreen[700],
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.brown[50],
  // Add other theme properties as needed
);