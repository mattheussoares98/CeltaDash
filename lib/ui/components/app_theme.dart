import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';

ThemeData makeAppTheme(BuildContext context) {
  final isIos = !kIsWeb && Platform.isIOS;

  const primaryColor = Color.fromARGB(255, 34, 139, 34); // ForestGreen
  const primaryColorDark = Color.fromARGB(255, 0, 100, 0); // DarkGreen
  const primaryColorLight = Color.fromARGB(255, 144, 238, 144); // LightGreen
  const secondaryColor = Color.fromARGB(255, 255, 193, 7); // Amber for contrast
  const disabledColor = CupertinoColors.inactiveGray;
  const dividerColor = CupertinoColors.separator;
  // const textColor = Colors.white;
  final scaffoldColor = IsDarkTheme.isDark
      ? Colors.grey[850]
      : CupertinoColors.systemGroupedBackground;
  final textColor = IsDarkTheme.isDark ? Colors.white : Colors.black;
  final cardColor = IsDarkTheme.isDark ? Colors.grey[900] : Colors.white;

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
      borderSide: const BorderSide(color: disabledColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
          const BorderSide(color: CupertinoColors.systemGrey4),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
          const BorderSide(color: CupertinoColors.destructiveRed),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor),
    ),
  );

  final buttonPadding = EdgeInsets.symmetric(
    vertical: ScreenSize.hasMinWidth ? 10 : 6,
    horizontal: ScreenSize.hasMinWidth ? 20 : 12,
  );

  return ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: scaffoldColor,
      selectedItemColor: IsDarkTheme.isDark ? primaryColorLight : primaryColor,
      unselectedItemColor: disabledColor,
    ),
    brightness: IsDarkTheme.isDark ? Brightness.dark : Brightness.light,
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    highlightColor: CupertinoColors.systemGrey4.withAlpha(50),
    secondaryHeaderColor: secondaryColor,
    disabledColor: disabledColor,
    dividerColor: dividerColor,
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 0,
    ),
    colorScheme: ColorScheme(
      brightness: IsDarkTheme.isDark ? Brightness.dark : Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      surface: IsDarkTheme.isDark ? Colors.grey[900]! : Colors.white,
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
            backgroundColor: IsDarkTheme.isDark
                ? scaffoldColor
                : CupertinoColors.extraLightBackgroundGray,
            elevation: 0,
            iconTheme: IconThemeData(
                color:
                    IsDarkTheme.isDark ? primaryColorLight : primaryColorDark),
            titleTextStyle: textTheme.titleLarge,
          )
        : AppBarTheme(
            backgroundColor: primaryColorLight.withAlpha(15),
            iconTheme: IconThemeData(
                color:
                    IsDarkTheme.isDark ? primaryColorLight : primaryColorDark),
          ),
    useMaterial3: true,
    iconTheme: const IconThemeData(color: primaryColorDark),
  );
}
