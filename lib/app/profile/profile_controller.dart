
import 'package:bismo/app/profile/profile_view.dart'as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:flutter/material.dart';

class ProfileController extends StatelessController {
  final String _title = 'Profile Page';
  const ProfileController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
   

    return Display(
      title: _title,
      mobile: mobile.ProfileView(title: _title),
    );
  }
}
