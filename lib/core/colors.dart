import 'package:flutter/material.dart';

class AppColors {
  // static const int _primary = 0xFF074db6;
  static const Color primaryColor = Colors.purple;
  static const int _redColor = 0xFFF14635;
  static const Color redColor = Color(_redColor);

  static const Color primary = Color.fromARGB(255, 7, 77, 182);

  static const Color scaffoldBackground = Color(0xFFFFFFFF);

  static const Color scaffoldWithBoxBackground = Color(0xFFF7F7F7);
  static const Color cardColor = Color(0xFFF2F2F2);
  static const Color coloredBackground = Color(0xFFE4F8EA);
  static const Color placeholder = Color(0xFF8B8B97);
  static const Color textInputBackground = Color(0xFFF7F7F7);
  static const Color separator = Color(0xFFFAFAFA);
  static const Color gray = Color(0xFFE1E1E1);

  static const Map<int, Color> color = {
    50: Color.fromRGBO(253, 253, 253, .1),
    100: Color.fromRGBO(253, 253, 253, .2),
    200: Color.fromRGBO(253, 253, 253, .3),
    300: Color.fromRGBO(253, 253, 253, .4),
    400: Color.fromRGBO(253, 253, 253, .5),
    500: Color.fromRGBO(253, 253, 253, .6),
    600: Color.fromRGBO(253, 253, 253, .7),
    700: Color.fromRGBO(253, 253, 253, .8),
    800: Color.fromRGBO(253, 253, 253, .9),
    900: Color.fromRGBO(253, 253, 253, 1),
  };

  static const int _bg = 0xFFFDFDFD;
  static const Color bgColor = Color(_bg);
  static const MaterialColor bgSwatchColor = MaterialColor(
    _bg,
    <int, Color>{
      50: Color.fromRGBO(253, 253, 253, .1),
      100: Color.fromRGBO(253, 253, 253, .2),
      200: Color.fromRGBO(253, 253, 253, .3),
      300: Color.fromRGBO(253, 253, 253, .4),
      400: Color.fromRGBO(253, 253, 253, .5),
      500: Color.fromRGBO(253, 253, 253, .6),
      600: Color.fromRGBO(253, 253, 253, .7),
      700: Color.fromRGBO(253, 253, 253, .8),
      800: Color.fromRGBO(253, 253, 253, .9),
      900: Color.fromRGBO(253, 253, 253, 1),
    },
  );

  static const int _textBlack = 0xFF252B42;
  static const Color textBlack = Color(_textBlack);

  // static const int _black = 0xFF222831;
  // static const MaterialColor black = MaterialColor(_black, {
  //   500: Color(_black),
  // });

  // static const int _space = 0xFF393E46;
  // static const MaterialColor space = MaterialColor(_space, {
  //   400: Color(0xFF424242),
  //   500: Color(_space),
  // });

  // static const int _grey = 0xEEEEEEEE;
  // static const MaterialColor grey = MaterialColor(_grey, {
  //   500: Color(_grey),
  // });

  // static const int _teal = 0xFF00ADB5;
  // static const MaterialColor teal = MaterialColor(
  //   _teal,
  //   <int, Color>{
  //     50: Color(0xFFE0F7FA),
  //     100: Color(0xFFB2EBF2),
  //     200: Color(0xFF80DEEA),
  //     300: Color(0xFF4DD0E1),
  //     400: Color(0xFF26C6DA),
  //     500: Color(_teal),
  //     600: Color(0xFF00ACC1),
  //     700: Color(0xFF0097A7),
  //     800: Color(0xFF00838F),
  //     900: Color(0xFF006064),
  //   },
  // );
}
