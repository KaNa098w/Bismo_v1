import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/models/order/detalization_order_response.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details_statuses.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details_total_amount_and_paid.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details_total_order_product_details.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({
    Key? key,
    required this.order,
    required this.categoryTotalSum,
  }) : super(key: key);

  final DetalizationOrderResponse? order;
  final double categoryTotalSum;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                'Номер заказа: ${order?.number}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 14),
              ),
            ),
            const SizedBox(height: AppDefaults.padding),
            OrderStatusColumn(
              order: order,
            ),
            TotalOrderProductDetails(
              order: order,
            ),
            TotalAmountAndPaidData(
              order: order,
            ),
          ],
        ),
      ),
    );
  }
}
