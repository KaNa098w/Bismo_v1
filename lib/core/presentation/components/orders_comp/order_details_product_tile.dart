import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/core/models/order/detalization_order_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OrderDetailsProductTile extends StatelessWidget {
  const OrderDetailsProductTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  final OrderGoods data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/product_goods',
        arguments: GoodsArguments(
          data.nomenklatura ?? '',
          data.kontragent ?? '',
          data.kontragent ?? '',
          data.price as int,
          data.nomenklaturaKod ?? '',
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 80,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: CachedNetworkImage(
                imageUrl: data.photo ?? "",
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/no_image.png',
                  fit: BoxFit.contain,
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.nomenklatura ?? "",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${data.price}₸/шт',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${data.step}шт в упаковке',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${data.basketCount} уп. было заказано ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
