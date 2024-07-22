import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDefaults.padding * 2),
      child: Row(
        children: [
          Text(
            'Войти',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              // Navigator.pushNamed(context, AppRoutes.numberVerification);
            },
            style: ElevatedButton.styleFrom(elevation: 1),
            child: SvgPicture.asset(
              AppIcons.arrowForward,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
