import 'package:bismo/core/presentation/components/orders_comp/dummy_order_status.dart';
import 'package:flutter/material.dart';

import 'order_status_row.dart';

class OrderStatusColumn extends StatelessWidget {
  const OrderStatusColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        OrderStatusRow(
          status: OrderStatus.confirmed,
          date: '12.12.2022',
          time: '11.00 ',
          isStart: true,
          isActive: true,
        ),
        OrderStatusRow(
          status: OrderStatus.processing,
          date: '12.12.2022',
          time: '13.00 ',
          isActive: true,
        ),
        OrderStatusRow(
          status: OrderStatus.shipped,
          date: '12.12.2022',
          time: '05.00 ',
          isActive: true,
        ),
        OrderStatusRow(
          status: OrderStatus.delivery,
          date: '12.12.2022',
          time: '19.00 ',
          isEnd: true,
        ),
      ],
    );
  }
}
