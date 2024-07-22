import 'package:bismo/app/config_screen/config_screen_view.dart' as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:flutter/material.dart';

class ConfigScreenController extends StatelessController {
  final String _title = 'Config Screen Page';
  const ConfigScreenController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    return Display(
      title: _title,
      mobile: mobile.ConfigScreenView(title: _title),
    );
  }
}
