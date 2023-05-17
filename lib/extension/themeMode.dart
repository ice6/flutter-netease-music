import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  bool isLight(BuildContext context) =>
      this == ThemeMode.light || this == ThemeMode.system &&
          MediaQuery.platformBrightnessOf(context) == Brightness.light;
}