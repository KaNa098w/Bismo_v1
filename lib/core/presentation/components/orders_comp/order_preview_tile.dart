import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/presentation/components/orders_comp/dummy_order_status.dart';
import 'package:flutter/material.dart';


class OrderPreviewTile extends StatelessWidget {
  const OrderPreviewTile({
    Key? key,
    required this.orderID,
    required this.date,
    required this.status,
    required this.onTap,
  }) : super(key: key);

  final String orderID;
  final String date;
  final OrderStatus status;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.padding,
        vertical: AppDefaults.padding / 2,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDefaults.borderRadius,
          child: Container(
            padding: const EdgeInsets.all(AppDefaults.padding),
            decoration: BoxDecoration(
              borderRadius: AppDefaults.borderRadius,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Номер заказа:'),
                    const SizedBox(width: 5),
                    Text(
                      '2324252627',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.black),
                    ),
                    const Spacer(),
                    const Text('25 январь'),
                  ],
                ),
                Row(
                  children: [
                    const Text('Статус'),
                    Expanded(
                      child: RangeSlider(
                        values: RangeValues(0, _orderSliderValue()),
                        max: 3,
                        divisions: 3,
                        onChanged: (v) {},
                        activeColor: _orderColor(),
                        inactiveColor: AppColors.placeholder.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Opacity(
                            opacity: status == OrderStatus.confirmed ? 1 : 0,
                            child: Text(
                              'Заказ принять',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: _orderColor()),
                            ),
                          ),
                          Opacity(
                            opacity: status == OrderStatus.processing ? 1 : 0,
                            child: Text(
                              'В процессе',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: _orderColor()),
                            ),
                          ),
                          Opacity(
                            opacity: status == OrderStatus.shipped ? 1 : 0,
                            child: Text(
                              'В пути',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: _orderColor()),
                            ),
                          ),
                          Opacity(
                            opacity: status == OrderStatus.delivery ||
                                    status == OrderStatus.cancelled
                                ? 1
                                : 0,
                            child: Text(
                              status == OrderStatus.delivery
                                  ? 'Доставлен'
                                  : 'Отменен',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: _orderColor()),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _orderSliderValue() {
    switch (status) {
      case OrderStatus.confirmed:
        return 0;
      case OrderStatus.processing:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.delivery:
        return 3;
      case OrderStatus.cancelled:
        return 3;

      default:
        return 0;
    }
  }

  Color _orderColor() {
    switch (status) {
      case OrderStatus.confirmed:
        return const Color(0xFF4044AA);
      case OrderStatus.processing:
        return const Color(0xFF41A954);
      case OrderStatus.shipped:
        return const Color(0xFFE19603);
      case OrderStatus.delivery:
        return const Color(0xFF41AA55);
      case OrderStatus.cancelled:
        return const Color(0xFFFF1F1F);

      default:
        return Colors.red;
    }
  }
}
