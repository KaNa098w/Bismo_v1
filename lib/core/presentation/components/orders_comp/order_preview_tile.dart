import 'dart:developer';

import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/exceptions.dart';
import 'package:bismo/core/helpers/other.dart';
import 'package:bismo/core/models/order/set_status_request.dart';
import 'package:bismo/core/presentation/components/orders_comp/dummy_order_status.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/dialogs/loader_dialog.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/order.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPreviewTile extends StatelessWidget {
  const OrderPreviewTile(
      {Key? key,
      required this.orderID,
      required this.date,
      required this.status,
      required this.onTap,
      required this.orderNumber,
      required order,
      required this.refresh})
      : super(key: key);

  final String orderID;
  final String date;
  final OrderStatus status;
  final void Function() onTap;
  final String orderNumber;
  final void Function() refresh;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Номер заказа:'),
                    const SizedBox(width: 5),
                    Text(
                      orderNumber,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.black),
                    ),
                    const Spacer(),
                    Text(formatDateWithTime(date, 'ru')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _getStatusText(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: _orderColor()),
                      ),
                    ),
                    if (status ==
                        OrderStatus
                            .confirmed) // Добавляем кнопку только если статус заказа подтвержден
                      ElevatedButton(
                        onPressed: () async {
                          var userProvider = context.read<UserProvider>();

                          SetStatusRequest setStatusRequest = SetStatusRequest(
                            uIDOrder: orderID,
                            user: userProvider.user?.phoneNumber ?? "",
                            status: '09',
                          );
                          await setStatus(setStatusRequest, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .white, // Устанавливаем красный цвет для кнопки
                        ),
                        child: const Text(
                          'Отменить заказ',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> setStatus(
      SetStatusRequest setStatusRequest, BuildContext ctx) async {
    showLoader(ctx);

    try {
      var res = await OrderService().setStatus(setStatusRequest);

      if (res != null) {
        if ((res.success ?? false) == false) {
          if (ctx.mounted) {
            hideLoader(ctx);
            showAlertDialog(
              context: ctx,
              barrierDismissible: true,
              title: "Ошибка",
              content: "Неудалось отменить заказ",
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(ctx).pop(),
                  textStyle: const TextStyle(color: AppColors.primaryColor),
                  child: const Text("OK"),
                ),
              ],
            );
          }

          return false;
        }

        if (ctx.mounted) {
          hideLoader(ctx);
          refresh();
        }

        return true;
      }
    } on DioException catch (e) {
      log(e.toString());
      final errorMessage = DioExceptions.fromDioError(e).toString();
      if (e.response?.statusCode == 401) {
        if (ctx.mounted) {
          hideLoader(ctx);
          showAlertDialog(
            context: ctx,
            barrierDismissible: true,
            title: "Ошибка",
            content: "Неправильный номер телефона или код из смс",
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                textStyle: const TextStyle(color: AppColors.primaryColor),
                child: const Text("OK"),
              ),
            ],
          );
        }
      } else {
        if (ctx.mounted) {
          hideLoader(ctx);
          showAlertDialog(
            context: ctx,
            barrierDismissible: true,
            title: "Ошибка",
            content: errorMessage,
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                textStyle: const TextStyle(color: AppColors.primaryColor),
                child: const Text("OK"),
              ),
            ],
          );
        }
      }

      return false;
    }

    return false;
  }

  String _getStatusText() {
    switch (status) {
      case OrderStatus.confirmed:
        return 'В обработке';
      case OrderStatus.processing:
        return 'В процессе';
      case OrderStatus.shipped:
        return 'В пути';
      case OrderStatus.delivery:
        return 'Доставлен';
      case OrderStatus.cancelled:
        return 'Заказ отменен';
      default:
        return '';
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
