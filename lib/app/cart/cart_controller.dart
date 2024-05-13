import 'package:bismo/app/cart/cart_view.dart' as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:bismo/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CartController extends StatelessController {
  final String _title = 'Корзина';
  const CartController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    

    return Display(
      title: _title,
      mobile: mobile.CartView(title: _title),
    );
  }
}
