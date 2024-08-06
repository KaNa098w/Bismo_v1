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
  final String fallbackImageAsset = 'assets/images/no_image.png';

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
            Navigator.pushNamed(
              context,
              '/product_goods',
              arguments: GoodsArguments(
                  data.nomenklatura ?? '',
                  data.catId ?? '',
                  data.kontragent ?? '',
                  data.price ?? 0,
                  data.nomenklaturaKod ?? ''),
            );
          },
          child: Container(
            width: 150,
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
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20.0), // Закругленные углы
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.network(
                        data.photo ?? '',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            fallbackImageAsset,
                            fit: BoxFit.contain,
                          );
                        },
                      ),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.typePrice != 'A'
                      ? data.typePrice!.map((typePrice) {
                          String formattedName = typePrice.name
                                  ?.replaceAllMapped(
                                      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                                      (Match m) => '${m[1]} ') ??
                              '0';
                          String formattedPrice = typePrice.price
                              .toString()
                              .replaceAllMapped(
                                  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                                  (Match m) => '${m[1]} ');
                          String formattedCategory =
                              typePrice.category.toString();

                          bool isBold = true == formattedCategory;

                          TextStyle textStyle = TextStyle(
                            fontSize: isBold ? 10 : 9,
                            fontWeight:
                                isBold ? FontWeight.bold : FontWeight.normal,
                          );

                          return typePrice.name != ""
                              ? Text(
                                  'от $formattedNameт - $formattedPrice₸',
                                  style: textStyle,
                                )
                              : Row(
                                  children: [
                                    const Text('Цена: '),
                                    Flexible(
                                      child: Text(
                                        '$formattedPrice₸/шт',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: isBold
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                );
                        }).toList()
                      : [
                          const SizedBox(
                            height: 1,
                          )
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
