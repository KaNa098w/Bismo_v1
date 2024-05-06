import 'package:bismo/app/catalog/goods/goods_view.dart' as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:bismo/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoodsController extends StatelessController {
  final String _title = 'Продукты и питания';
  const GoodsController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
   

    return Display(
      title: _title,
      mobile: mobile.GoodsView(title: _title),
    );
  }
}
