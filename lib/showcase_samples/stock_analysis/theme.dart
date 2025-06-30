import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xff007BFF),
    brightness: Brightness.light,
  );
}

ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xff007BFF),
    brightness: Brightness.dark,
  );
}
