import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/dummy_data.dart';
import 'package:bismo/core/presentation/widgets/bundle_tile_square.dart';
import 'package:bismo/core/presentation/widgets/title_and_action_button.dart';
import 'package:flutter/material.dart';

class PopularPacks extends StatelessWidget {
  const PopularPacks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleAndActionButton(
          title: 'Популярные товары',
          onTap: () {
            //  Navigator.pushNamed(context, AppRoutes.popularItems)
          },
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.only(left: AppDefaults.padding),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              Dummy.bundles.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: AppDefaults.padding),
                child: BundleTileSquare(data: Dummy.bundles[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
