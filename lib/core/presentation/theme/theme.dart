import 'package:celta_dash/core/presentation/theme/app_colors.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'theme_data.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  primaryColorLight: AppColors.primaryLight,
  colorScheme: colorScheme,
  secondaryHeaderColor: AppColors.secondary,
  // fontFamily: 'Poppins',
  scaffoldBackgroundColor: AppColors.surface,
  appBarTheme: appBarTheme,
  iconTheme: iconThemeData,
  iconButtonTheme: iconButtonThemeData,
  inputDecorationTheme: inputDecorationTheme,
  elevatedButtonTheme: getElevatedButtonTheme(colorScheme),
  outlinedButtonTheme: outlinedButtonTheme,
  chipTheme: getChipTheme(colorScheme),
  checkboxTheme: getCheckBoxTheme(colorScheme),
  listTileTheme: listTileThemeData,
  bottomNavigationBarTheme: bottomNavigationBarTheme,
  expansionTileTheme: expansionTileThemeData,
  cardTheme: cardTheme,
  progressIndicatorTheme: progressIndicatorTheme,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  primaryColorLight: AppColors.primaryLight,
  colorScheme: darkColorScheme,
  // fontFamily: 'Poppins',
  scaffoldBackgroundColor: const Color(0xFF121214),
  appBarTheme: darkAppBarTheme,
  iconTheme: darkIconThemeData,
  iconButtonTheme: iconButtonThemeData,
  inputDecorationTheme: darkInputDecorationTheme,
  elevatedButtonTheme: getElevatedButtonTheme(darkColorScheme),
  outlinedButtonTheme: outlinedButtonTheme,
  chipTheme: getChipTheme(darkColorScheme),
  checkboxTheme: getCheckBoxTheme(darkColorScheme),
  listTileTheme: listTileThemeData,
  bottomNavigationBarTheme: darkBottomNavigationBarTheme,
  expansionTileTheme: darkExpansionTileThemeData,
  cardTheme: darkCardTheme,
  progressIndicatorTheme: progressIndicatorTheme,
);
