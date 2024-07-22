import 'package:bismo/core/constants/app_defaults.dart';
import 'package:flutter/material.dart';


class AppSettingsListTile extends StatelessWidget {
  const AppSettingsListTile({
    Key? key,
    required this.label,
    this.trailing,
    this.onTap,
  }) : super(key: key);
final Widget? trailing;
  final void Function()? onTap;
  final String label;
  

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppDefaults.borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDefaults.borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  const Spacer(),
                  if (trailing != null) trailing!,
                ],
              ),
              const Divider(thickness: 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
