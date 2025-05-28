import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';

ThemeData makeAppTheme(BuildContext context) {
  final isIos = !kIsWeb && Platform.isIOS;
  final isDarkMode =
      MediaQuery.of(context).platformBrightness == Brightness.dark;

  const primaryColor = Color.fromARGB(255, 34, 139, 34); // ForestGreen
  const primaryColorDark = Color.fromARGB(255, 0, 100, 0); // DarkGreen
  const primaryColorLight = Color.fromARGB(255, 144, 238, 144); // LightGreen
  const secondaryColor = Color.fromARGB(255, 255, 193, 7); // Amber for contrast
  final disabledColor = CupertinoColors.inactiveGray;
  const dividerColor = CupertinoColors.separator;
  // const textColor = Colors.white;
  final scaffoldColor =
      isDarkMode ? Colors.black : CupertinoColors.systemGroupedBackground;
  final textColor = isDarkMode ? Colors.white : Colors.black;
  final cardColor = isDarkMode ? Colors.grey[900] : Colors.white;

  final textTheme = TextTheme(
    bodySmall: TextStyle(
      fontSize: 12,
      color: textColor,
      fontFamily: '.SF Pro Text',
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: textColor,
      fontFamily: '.SF Pro Text',
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: textColor,
      fontFamily: '.SF Pro Text',
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      color: textColor,
      fontFamily: '.SF Pro Text',
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      color: textColor,
      fontFamily: '.SF Pro Text',
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      color: textColor,
      fontFamily: '.SF Pro Text',
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: textColor,
      fontFamily: '.SF Pro Text',
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: textColor,
      fontFamily: '.SF Pro Text',
    ),
    displayLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: textColor,
      fontFamily: '.SF Pro Text',
    ),
  );

  final inputDecorationTheme = InputDecorationTheme(
    labelStyle: const TextStyle(
      color: primaryColorDark,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    filled: true,
    fillColor: CupertinoColors.systemGrey6,
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: disabledColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: CupertinoColors.systemGrey4),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
          const BorderSide(width: 1, color: CupertinoColors.destructiveRed),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1, color: primaryColor),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1, color: primaryColor),
    ),
  );

  final buttonPadding = EdgeInsets.symmetric(
    vertical: ScreenSize.hasMinWidth ? 10 : 6,
    horizontal: ScreenSize.hasMinWidth ? 20 : 12,
  );

  return ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: scaffoldColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: disabledColor,
    ),
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    highlightColor: CupertinoColors.systemGrey4.withOpacity(0.2),
    secondaryHeaderColor: secondaryColor,
    disabledColor: disabledColor,
    dividerColor: dividerColor,
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 0,
    ),
    colorScheme: ColorScheme(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      surface: isDarkMode ? Colors.grey[900]! : Colors.white,
      onSurface: textColor,
    ),
    scaffoldBackgroundColor: scaffoldColor,
    textTheme: textTheme,
    inputDecorationTheme: inputDecorationTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColorDark,
        foregroundColor: Colors.white,
        padding: buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColorDark,
        padding: buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    appBarTheme: isIos
        ? AppBarTheme(
            backgroundColor: CupertinoColors.extraLightBackgroundGray,
            elevation: 0,
            iconTheme: IconThemeData(
                color: isDarkMode ? primaryColorLight : primaryColorDark),
            titleTextStyle: const TextStyle(
              color: primaryColorDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: '.SF Pro Text',
            ),
          )
        : AppBarTheme(
            backgroundColor: primaryColorLight.withAlpha(15),
            iconTheme: IconThemeData(
                color: isDarkMode ? primaryColorLight : primaryColorDark),
          ),
    useMaterial3: true,
  );
}
