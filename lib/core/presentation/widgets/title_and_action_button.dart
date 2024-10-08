import 'package:bismo/core/constants/app_defaults.dart';
import 'package:flutter/material.dart';

class TitleAndActionButton extends StatelessWidget {
  const TitleAndActionButton({
    Key? key,
    required this.title,
    this.actionLabel,
    required this.onTap,
    this.isHeadline = true,
  }) : super(key: key);

  final String title;
  final String? actionLabel;
  final void Function() onTap;
  final bool isHeadline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isHeadline
                ? Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.black)
                : Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.black),
          ),
          TextButton(
            onPressed: (){
              Navigator.pushNamed(context, '/all_view');
            },
            child: Text(actionLabel ?? 'показать всё', style: const TextStyle(fontSize: 13),),
          ),
        ],
      ),
    );
  }
}
