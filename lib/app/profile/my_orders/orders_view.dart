import 'package:bismo/core/colors.dart';
import 'package:bismo/core/presentation/components/orders_comp/custom_tab_label.dart';
import 'package:bismo/core/presentation/components/orders_comp/tab_all.dart';
import 'package:bismo/core/presentation/components/orders_comp/tab_completed.dart';
import 'package:bismo/core/presentation/components/orders_comp/tab_running.dart';
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
          bottom: const TabBar(
            physics: NeverScrollableScrollPhysics(),
            tabs: [
              CustomTabLabel(label: 'Все', value: '(58)'),
              CustomTabLabel(label: 'В пути', value: '(14)'),
              CustomTabLabel(label: 'История', value: '(44)'),
            ],
          ),
        ),
        body: Container(
          color: AppColors.cardColor,
          child: const TabBarView(
            children: [
              AllTab(),
              RunningTab(),
              CompletedTab(),
            ],
          ),
        ),
      ),
    );
  }
}
