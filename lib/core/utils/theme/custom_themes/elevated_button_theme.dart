import 'package:flutter/material.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._(); // To avoid creating instances

  /// -- Light Theme
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Color(0xff227D48),
      disabledForegroundColor: Colors.grey.withOpacity(0.38),
      disabledBackgroundColor: Colors.grey.withOpacity(0.12),
      side: const BorderSide(color: Color(0xff5DB957),),
      padding: const EdgeInsets.symmetric(vertical: 10),
      textStyle: const TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w800,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );

  /// -- Dark Theme
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Color(0xff227D48),
      disabledForegroundColor: Colors.grey,
      disabledBackgroundColor: Colors.grey,
      side: const BorderSide(color: Color(0xff5DB957),),
      padding: const EdgeInsets.symmetric(vertical: 10),
      textStyle: const TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w800,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}
