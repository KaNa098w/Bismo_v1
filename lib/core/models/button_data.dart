import 'package:flutter/material.dart';

class ButtonData {
  Widget? page;
  IconData icon;
  String labelRu;
  String labelKk;
  String labelEn;
  String? link;
  bool isProtected;

  ButtonData(
      {this.page,
      required this.icon,
      required this.labelRu,
      required this.labelKk,
      required this.labelEn,
      this.link,
      required this.isProtected});
}
