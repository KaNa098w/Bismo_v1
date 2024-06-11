import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/app/catalog/goods/goods_view.dart' as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:flutter/material.dart';

class GoodsController extends StatelessController {
  final String _title = 'Продукты и питания';
  const GoodsController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as GoodsArguments;
    return Display(
      title: _title,
      mobile: mobile.GoodsView(
        title: args.title,
        catId: args.catId,
        kontragent: args.kontragent,
        price: args.price,
        nomenklaturaKod: args.nomenklaturaKod,
      ),
    );
  }
}
