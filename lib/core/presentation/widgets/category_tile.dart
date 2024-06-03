import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/presentation/widgets/network_image.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    Key? key,
    required this.imageLink,
    required this.label,
    this.backgroundColor,
    required this.onTap,
    this.iconSize = 65,
  }) : super(key: key);

  final String imageLink;
  final String label;
  final Color? backgroundColor;
  final void Function() onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBackground,
      child: InkWell(
        borderRadius: AppDefaults.borderRadius,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDefaults.padding),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: iconSize,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(iconSize / 2),
                    child: NetworkImageWithLoader(
                      imageLink,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: iconSize * 2, // Увеличиваем ширину контейнера для текста
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
