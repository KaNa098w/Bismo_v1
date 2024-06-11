import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/models/order/get_new_goods.dart';
import 'package:flutter/material.dart';

class ProductTileSquare extends StatelessWidget {
  const ProductTileSquare({
    Key? key,
    required this.data,
    required this.newGoodsFuture,
  }) : super(key: key);

  final Goods data;
  final Future<GetNewGoodsResponse?> newGoodsFuture;
  final String fallbackImageUrl =
      'https://images.satu.kz/197787004_w200_h200_pomада-для-губ.jpg';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding / 2),
      child: Material(
        borderRadius: AppDefaults.borderRadius,
        color: AppColors.scaffoldBackground,
        child: InkWell(
          borderRadius: AppDefaults.borderRadius,
          onTap: () async {
            // final snapshot = await newGoodsFuture;
            // if (snapshot != null &&
            //     snapshot.goods != null &&
            //     snapshot.goods!.isNotEmpty) {
              // final goods = snapshot.goods!
              //     .first; // Используйте первый элемент или измените логику по необходимости
              Navigator.pushNamed(
                context,
                '/product_goods',
                arguments: GoodsArguments(
                  data.nomenklatura ?? '',
                  data.catId ?? '',
                  data.kontragent ?? '',
                  data.price ?? 0,
                  data.nomenklaturaKod ?? '',
                ),
              );
            // }
          },
          child: Container(
            width: 176,
            padding: const EdgeInsets.all(AppDefaults.padding),
            decoration: BoxDecoration(
              border: Border.all(width: 0.1, color: AppColors.placeholder),
              borderRadius: AppDefaults.borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppDefaults.padding / 2),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image.network(
                      data.photo ?? fallbackImageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          fallbackImageUrl,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.nomenklatura ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Text(
                  data.count ?? '',
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${data.price ?? 0}₸',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${data.oldPrice ?? 0}₸',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
