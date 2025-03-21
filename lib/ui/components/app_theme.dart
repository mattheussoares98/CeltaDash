import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';

ThemeData makeAppTheme(BuildContext context) {
  const primaryColor = Colors.black54;
  const primaryColorDark = Colors.black87;
  const primaryColorLight = Colors.black38;
  const secondaryColor = Color.fromARGB(255, 76, 175, 80);
  final disabledColor = Colors.grey[400];
  const dividerColor = Colors.grey;
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
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 1,
        color: disabledColor!,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 1,
        color: disabledColor,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        width: 1,
        color: Colors.red,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        width: 1,
        color: primaryColor,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        width: 1,
        color: primaryColor,
      ),
    ),
  );
  final buttonTheme = ButtonThemeData(
    colorScheme: const ColorScheme.light(primary: primaryColor),
    buttonColor: primaryColor,
    splashColor: primaryColorLight,
    padding: EdgeInsets.symmetric(
      vertical: hasMinWidth(context) ? 10 : 2,
      horizontal: hasMinWidth(context) ? 20 : 5,
    ),
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  );

  final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(
        vertical: hasMinWidth(context) ? 10 : 2,
        horizontal: hasMinWidth(context) ? 20 : 5,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: primaryColorDark,
      foregroundColor: Colors.white,
    ),
  );

  AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: primaryColorLight.withAlpha(15),
  );

  final textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: primaryColorDark),
  );

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    highlightColor: primaryColorDark,
    secondaryHeaderColor: secondaryColor,
    disabledColor: disabledColor,
    dividerColor: dividerColor,
    colorScheme: const ColorScheme.light(primary: primaryColor),
    // backgroundColor: Colors.white, deprecated
    textTheme: textTheme,
    inputDecorationTheme: inputDecorationTheme,
    buttonTheme: buttonTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    appBarTheme: appBarTheme,
    textButtonTheme: textButtonTheme,
  );
}
