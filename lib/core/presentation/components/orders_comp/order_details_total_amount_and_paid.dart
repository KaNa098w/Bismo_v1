import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/models/order/detalization_order_response.dart';
import 'package:flutter/material.dart';

class TotalAmountAndPaidData extends StatelessWidget {
  const TotalAmountAndPaidData({Key? key, required this.order})
      : super(key: key);

  final DetalizationOrderResponse? order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Общая сумма',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const Spacer(),
              Text(
                '${order?.orderSum}₸',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Expanded(
          //   child: Row(
          //     children: [
          //       Text(
          //         'Адрес доставки',
          //         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          //             fontWeight: FontWeight.bold, color: Colors.black),
          //       ),
          //       const Spacer(),
          //       RichText(
          //         text: TextSpan(text: '${order?.deliveryAddress}'),
          //       ),
          //     ],
          //   ),
          // ),
          Row(
            children: [
              Text(
                'Было оплачено',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const Spacer(),
              Text(
                'Налично',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}