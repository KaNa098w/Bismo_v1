import 'package:bismo/core/presentation/components/orders_comp/dummy_order_status.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details.dart';
import 'package:flutter/material.dart';

import 'order_preview_tile.dart';

class AllTab extends StatelessWidget {
  const AllTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8),
      children: [
        OrderPreviewTile(
          orderID: '232425627',
          date: '25 январь',
          status: OrderStatus.confirmed,
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderDetailsPage()),
            )
          },
        ),
        OrderPreviewTile(
          orderID: '232425627',
          date: '25 январь',
          status: OrderStatus.processing,
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderDetailsPage()),
            )
          },
        ),
        OrderPreviewTile(
          orderID: '232425627',
          date: '25 январь',
          status: OrderStatus.shipped,
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderDetailsPage()),
            )
          },
        ),
        OrderPreviewTile(
          orderID: '232425627',
          date: '25 январь',
          status: OrderStatus.delivery,
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderDetailsPage()),
            )
          },
        ),
        OrderPreviewTile(
          orderID: '232425627',
          date: '25 январь',
          status: OrderStatus.cancelled,
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderDetailsPage()),
            )
          },
        ),
      ],
    );
  }
}
