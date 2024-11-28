import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/theme/custom_themes/appbar_theme.dart';
import 'package:hyper_market/core/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:hyper_market/core/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:hyper_market/core/utils/theme/custom_themes/chip_theme.dart';
import 'package:hyper_market/core/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:hyper_market/core/utils/theme/custom_themes/outline_button_theme.dart';
import 'package:hyper_market/core/utils/theme/custom_themes/text_field_theme.dart';
import 'package:hyper_market/core/utils/theme/custom_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    brightness: Brightness.light,
    primaryColor: Color(0xff5DB957),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    chipTheme: TChipTheme.lightChipTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: TOutlinedButtonTheme.lightOutlinedButtonTheme),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    brightness: Brightness.dark,
    primaryColor: Color(0xff227D48),
    scaffoldBackgroundColor: const Color.fromARGB(255, 19, 19, 19),
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    chipTheme: TChipTheme.darkChipTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: TOutlinedButtonTheme.darkOutlinedButtonTheme),
  );
}
