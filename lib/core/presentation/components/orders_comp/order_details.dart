import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/models/order/order_model.dart';
import 'package:bismo/core/presentation/components/orders_comp/app_back_button.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details_statuses.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details_total_amount_and_paid.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details_total_order_product_details.dart';
import 'package:flutter/material.dart';


class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({Key? key, required Order order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Детали заказа'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(AppDefaults.margin),
          padding: const EdgeInsets.all(AppDefaults.padding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppDefaults.borderRadius,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Номер заказа: 30398505202',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: AppDefaults.padding),
              const OrderStatusColumn(),
              const TotalOrderProductDetails(),
              const TotalAmountAndPaidData(),
            ],
          ),
        ),
      ),
    );
  }
}
