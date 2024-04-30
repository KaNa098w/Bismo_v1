import 'package:bismo/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  ThemeData? light;
  ThemeData? dark;

  AppTheme([
    this.light,
    this.dark,
  ]) {
    light = light ??
        ThemeData(
            brightness: Brightness.light,
            primarySwatch: AppColors.bgSwatchColor,
            scaffoldBackgroundColor: AppColors.bgColor,
            primaryColor: AppColors.primaryColor,
            textSelectionTheme: const TextSelectionThemeData(
              selectionColor: Colors.grey,
              cursorColor: Color(0xff171d49),
              selectionHandleColor: Color(0xff005e91),
            ),
            useMaterial3: true,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            fontFamily: 'Montserrat',
            // textTheme: const TextTheme(
            //   bodyMedium: TextStyle(fontWeight: FontWeight.w600),
            //   bodyLarge: TextStyle(fontWeight: FontWeight.w600),
            //   bodySmall: TextStyle(fontWeight: FontWeight.w600),
            //   displayMedium: TextStyle(fontWeight: FontWeight.w600),
            //   displayLarge: TextStyle(fontWeight: FontWeight.w600),
            //   displaySmall: TextStyle(fontWeight: FontWeight.w600),
            // ),
            appBarTheme: const AppBarTheme(
                surfaceTintColor: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle.dark));

    dark = dark ??
        ThemeData(
            // brightness: Brightness.light,
            brightness: Brightness.dark,
            primarySwatch: AppColors.bgSwatchColor,
            scaffoldBackgroundColor: AppColors.bgColor,
            primaryColor: AppColors.primaryColor,
            textSelectionTheme: const TextSelectionThemeData(
              selectionColor: Colors.grey,
              cursorColor: Color(0xff171d49),
              selectionHandleColor: Color(0xff005e91),
            ),
            useMaterial3: true,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            fontFamily: 'Montserrat',
            appBarTheme: const AppBarTheme(
                surfaceTintColor: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle.dark));
  }

  ThemeData get lightTheme => light!;
  ThemeData get darkTheme => dark!;

  AppTheme copyWith({
    ThemeData? light,
    ThemeData? dark,
  }) {
    return AppTheme(
      light ?? this.light,
      dark ?? this.dark,
    );
  }
}
