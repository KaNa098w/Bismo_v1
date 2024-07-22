import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/presentation/widgets/dotted_divider.dart';
import 'package:flutter/material.dart';

import 'item_row.dart';

class ItemTotalsAndPrice extends StatelessWidget {
  const ItemTotalsAndPrice({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppDefaults.padding),
      child: Column(
        children: [
          ItemRow(
            title: 'Количество товаров ',
            value: '6',
          ),
         
          ItemRow(
            title: 'Цена',
            value: '8 350₸',
          ),
          ItemRow(
            title: 'Скидка',
            value: '-1 225₸',
          ),
          DottedDivider(),
          ItemRow(
            title: 'Общая стоимость',
            value: '7 125₸',
          ),
        ],
      ),
    );
  }
}
