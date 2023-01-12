// ignore_for_file: deprecated_member_use

import 'package:eklezia/widgets/colors.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      shadowColor: isDarkTheme ? const Color(0xFF010013) : AppColors.activColor,
      dialogBackgroundColor:
          isDarkTheme ? AppColors.activColor : AppColors.mainColor,
      scaffoldBackgroundColor:
          isDarkTheme ? const Color(0xFF010013) : AppColors.mainColor,
      colorSchemeSeed: AppColors.activColor,
      backgroundColor:
          isDarkTheme ? const Color(0xFF010013) : AppColors.mainColor,
      indicatorColor: const Color(0xFFABCDD7),
      buttonColor: isDarkTheme ? AppColors.mainColor : AppColors.mainColor,
      hintColor: isDarkTheme ? AppColors.mainColor : AppColors.bigTextColor,
      cardColor: isDarkTheme ? const Color(0x79F1F0E9) : AppColors.textColor2,
      hoverColor:
          isDarkTheme ? const Color(0xFF808995) : AppColors.simpleFondColor2,
      focusColor:
          isDarkTheme ? const Color(0xFF404D65) : AppColors.simpleFondColor,
      dividerColor: isDarkTheme ? const Color(0xFF808995) : Colors.white,
      bottomAppBarColor:
          isDarkTheme ? AppColors.activColor : AppColors.mainTextColor,
      disabledColor:
          isDarkTheme ? AppColors.mainColor : AppColors.mainTextColor,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      canvasColor:
          isDarkTheme ? const Color(0xFF808995) : AppColors.mainTextColor,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
    );
  }
}
// Color.fromARGB(255, 31, 38, 49)
// Theme.of(context).hintColor)