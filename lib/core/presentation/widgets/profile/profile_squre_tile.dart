import 'package:bismo/core/constants/app_defaults.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class ProfileSqureTile extends StatelessWidget {
  const ProfileSqureTile({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconSize = 24.0, // Добавьте параметр для размера иконки с значением по умолчанию
  }) : super(key: key);

  final String label;
  final String icon;
  final void Function() onTap;
  final double iconSize; // Добавьте поле для размера иконки

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDefaults.borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppDefaults.padding),
          child: Column(
            children: [
              SvgPicture.asset(
                icon,
                width: iconSize, // Укажите размер иконки
                height: iconSize, // Укажите размер иконки
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
