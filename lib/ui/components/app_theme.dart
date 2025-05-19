import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';

ThemeData makeAppTheme(BuildContext context) {
  const primaryColor = Colors.black;
  const primaryColorDark = Colors.black;
  const primaryColorLight = Colors.black54;
  const secondaryColor = CupertinoColors.systemGreen;
  final disabledColor = CupertinoColors.inactiveGray;
  const dividerColor = CupertinoColors.separator;
  if (!kIsWeb && Platform.isIOS) {
    const textTheme = TextTheme(
      displayLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primaryColorDark,
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
      vertical: hasMinWidth(context) ? 10 : 6,
      horizontal: hasMinWidth(context) ? 20 : 12,
    );

    return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      highlightColor: CupertinoColors.systemGrey4.withOpacity(0.2),
      secondaryHeaderColor: secondaryColor,
      disabledColor: disabledColor,
      dividerColor: dividerColor,
      colorScheme: const ColorScheme.light(primary: primaryColor),
      scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      textTheme: textTheme,
      inputDecorationTheme: inputDecorationTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: CupertinoColors.white,
          padding: buttonPadding,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: buttonPadding,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColorDark),
        titleTextStyle: const TextStyle(
          color: primaryColorDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: '.SF Pro Text',
        ),
      ),
      useMaterial3: true,
    );
  }

  // Default (Android / Web / Others)
  const textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: primaryColorDark,
    ),
  );

  final inputDecorationTheme = InputDecorationTheme(
    labelStyle: const TextStyle(
      color: primaryColorDark,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(width: 1, color: disabledColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(width: 1, color: disabledColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 1, color: primaryColor),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 1, color: primaryColor),
    ),
  );

  final buttonPadding = EdgeInsets.symmetric(
    vertical: hasMinWidth(context) ? 10 : 2,
    horizontal: hasMinWidth(context) ? 20 : 5,
  );

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    highlightColor: primaryColorLight.withAlpha(50),
    secondaryHeaderColor: secondaryColor,
    disabledColor: disabledColor,
    dividerColor: dividerColor,
    colorScheme: const ColorScheme.light(primary: primaryColor),
    textTheme: textTheme,
    inputDecorationTheme: inputDecorationTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: primaryColorDark,
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primaryColorDark),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColorLight.withAlpha(15),
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: const ColorScheme.light(primary: primaryColor),
      buttonColor: primaryColor,
      padding: buttonPadding,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    useMaterial3: true,
  );
}
