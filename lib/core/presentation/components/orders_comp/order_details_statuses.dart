import 'package:bismo/core/models/order/detalization_order_response.dart';
import 'package:bismo/core/presentation/components/orders_comp/dummy_order_status.dart';
import 'package:flutter/material.dart';

import 'order_status_row.dart';

class OrderStatusColumn extends StatelessWidget {
  const OrderStatusColumn({Key? key, required this.order}) : super(key: key);

  final DetalizationOrderResponse? order;

  @override
  Widget build(BuildContext context) {
    String currentStatus = _getStatus(order?.status);

    return Column(
      children: [
        OrderStatusRow(
          status: OrderStatus.confirmed,
          date: '',
          time: '',
          isActive: currentStatus != 'unknown',
        ),
        OrderStatusRow(
          status: OrderStatus.processing,
          date: '',
          time: '',
          isActive: currentStatus == 'processing' ||
              currentStatus == 'shipped' ||
              currentStatus == 'delivery',
        ),
        OrderStatusRow(
          status: OrderStatus.shipped,
          date: '',
          time: '',
          isActive: currentStatus == 'shipped' || currentStatus == 'delivery',
          isEnd: currentStatus == 'delivery',
        ),
        OrderStatusRow(
          status: OrderStatus.delivery,
          date: '',
          time: '',
          isActive: currentStatus == 'delivery',
          isEnd: true,
        ),
      ],
    );
  }

  static String _getStatus(int? status) {
    switch (status) {
      case 0:
        return 'confirmed';
      case 1:
        return 'processing';
      case 2:
        return 'shipped';
      case 3:
        return 'delivery';
      case 4:
        return 'cancelled';
      default:
        return 'unknown';
    }
  }
}
