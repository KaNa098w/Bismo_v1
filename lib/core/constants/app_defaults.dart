import 'package:flutter/material.dart';

class AppDefaults {
  static const double radius = 12;
  static const double margin = 12;
  static const double padding = 12;

  /// Used For Border Radius
  static BorderRadius borderRadius = BorderRadius.circular(radius);

  /// Used For Bottom Sheet
  static BorderRadius bottomSheetRadius = const BorderRadius.only(
    topLeft: Radius.circular(radius),
    topRight: Radius.circular(radius),
  );

  /// Used For Top Sheet
  static BorderRadius topSheetRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(radius),
    bottomRight: Radius.circular(radius),
  );

  /// Default Box Shadow used for containers
  static List<BoxShadow> boxShadow = [
    const BoxShadow(
      blurRadius: 0,
      spreadRadius: 0,
      offset: Offset(0, 0),
      color: Colors.white,
    ),
  ];

  static Duration duration = const Duration(milliseconds: 300);
}
