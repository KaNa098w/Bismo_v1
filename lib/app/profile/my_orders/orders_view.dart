import 'package:bismo/core/colors.dart';
import 'package:bismo/core/presentation/components/orders_comp/tab_all.dart';
import 'package:bismo/core/presentation/widgets/app_back_button.dart';
import 'package:flutter/material.dart';

class OrdersView extends StatefulWidget {
  final String? title;
  const OrdersView({Key? key, this.title}) : super(key: key);

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: const Text('Мои заказы'),
        ),
        body: Container(
          color: AppColors.cardColor,
          child: const AllTab(),
        ),
      ),
    );
  }
}
