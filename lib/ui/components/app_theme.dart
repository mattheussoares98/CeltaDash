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
  final disabledColor = secondaryColor.withAlpha(100);
  const dividerColor = CupertinoColors.separator;
  // const textColor = Colors.white;

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
            iconTheme: const IconThemeData(color: primaryColorDark),
            titleTextStyle: const TextStyle(
              color: primaryColorDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: '.SF Pro Text',
            ),
          )
        : AppBarTheme(
            backgroundColor: primaryColorLight.withAlpha(15),
          ),
    useMaterial3: true,
  );
}
