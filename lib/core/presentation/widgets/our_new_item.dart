import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/dummy_data.dart';
import 'package:bismo/core/presentation/widgets/product_tile_square.dart';
import 'package:bismo/core/presentation/widgets/title_and_action_button.dart';
import 'package:flutter/material.dart';

class OurNewItem extends StatelessWidget {
  const OurNewItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleAndActionButton(
          title: 'Новинки',
          onTap: () {
            // Navigator.pushNamed(context, AppRoutes.newItems)
          },
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.only(left: AppDefaults.padding),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              Dummy.products.length,
              (index) => ProductTileSquare(data: Dummy.products[index]),
            ),
          ),
        ),
      ],
    );
  }
}
