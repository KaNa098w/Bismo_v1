import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/app/catalog/goods/product/product_goods_view.dart'
    as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:flutter/material.dart';

class ProductGoodsController extends StatelessController {
  final String _title = 'Магазин';
  const ProductGoodsController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as GoodsArguments;
    return Display(
      title: _title,
      mobile: mobile.ProductGoodsView(
        goods: Goods(
          catId: args.catId,
        ),
      ),
    );
  }
}
