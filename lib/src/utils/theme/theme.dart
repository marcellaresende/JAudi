import 'package:flutter/material.dart';
import 'package:jaudi/src/utils/theme/text_field_dart.dart';
import 'package:jaudi/src/utils/theme/text_theme.dart';


import 'elevated_button_theme.dart';
import 'outlined_button_theme.dart';

class ThemeApp {

  ThemeApp._();

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      textTheme: ThemeText.lightTextTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      textTheme: ThemeText.darkTextTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
      elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}