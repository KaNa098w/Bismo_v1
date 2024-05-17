import 'package:bismo/app/profile/order_item/order_item_arguments.dart';
import 'package:bismo/app/profile/order_item/order_item_view.dart' as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:flutter/material.dart';

class OrderItemController extends StatelessController {
  final String _title = 'Order Item Page';
  const OrderItemController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as OrderItemArguments;

    return Display(
      title: _title,
      mobile: mobile.OrderItemView(title: _title, orderItem: args.orderItem),
    );
  }
}
