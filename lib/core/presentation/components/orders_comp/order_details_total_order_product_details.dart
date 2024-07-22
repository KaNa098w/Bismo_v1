import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/models/order/detalization_order_response.dart';
import 'package:flutter/material.dart';

import 'order_details_product_tile.dart';

class TotalOrderProductDetails extends StatelessWidget {
  const TotalOrderProductDetails({Key? key, required this.order})
      : super(key: key);

  final DetalizationOrderResponse? order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Детали продукта',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            itemBuilder: (context, index) {
              return OrderDetailsProductTile(data: order!.goods![index]);
            },
            separatorBuilder: (context, index) => const Divider(
              thickness: 1,
            ),
            itemCount: order!.goods!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }
}
