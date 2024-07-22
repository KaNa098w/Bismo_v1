import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final void Function() onTap;
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDefaults.borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 30.0, // Set the width
                height: 30.0, // Set the height
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.black),
              ),
              const Spacer(),
              SvgPicture.asset(
                AppIcons.right,
                width: 24.0, // Set the width
                height: 24.0, // Set the height
                color: Colors.purple, // Set the color to purple
              ),
            ],
          ),
        ),
      ),
    );
  }
}
