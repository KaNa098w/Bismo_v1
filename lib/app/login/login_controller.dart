import 'package:bismo/app/login/login_view.dart' as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:flutter/material.dart';

class LoginController extends StatelessController {
  final String _title = 'Login Page';
  const LoginController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    return Display(
      title: _title,
      mobile: mobile.LoginView(title: _title),
    );
  }
}
