import 'package:bismo/core/colors.dart';
import 'package:bismo/core/presentation/widgets/profile/profile_header.dart';
import 'package:bismo/core/presentation/widgets/profile/profile_menu_options.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final String? title;
  const ProfileView({Key? key, this.title}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.cardColor,
        child: const Column(
          children: [
            ProfileHeader(),
            ProfileMenuOptions(),
          ],
        ),
      ),
    );
  }
}
