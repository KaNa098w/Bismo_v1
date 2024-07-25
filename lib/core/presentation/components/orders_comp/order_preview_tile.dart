import 'dart:developer';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/exceptions.dart';
import 'package:bismo/core/helpers/other.dart';
import 'package:bismo/core/models/order/get_my_order_list_response.dart';
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

class OrderPreviewTile extends StatefulWidget {
  const OrderPreviewTile({
    Key? key,
    required this.orderID,
    required this.date,
    required this.status,
    required this.onTap,
    required this.orderNumber,
    required this.refresh,
    required this.sumOrder,
    // ignore: non_constant_identifier_names
    required this.provider_name,
    required JSONBody order,
  }) : super(key: key);

  final String sumOrder;
  final String orderID;
  final String date;
  final OrderStatus? status;
  final void Function() onTap;
  final String orderNumber;
  final void Function() refresh;
  final String provider_name;

  @override
  _OrderPreviewTileState createState() => _OrderPreviewTileState();
}

class _OrderPreviewTileState extends State<OrderPreviewTile> {
  bool _isCancelled = false;

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
          onTap: widget.onTap,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Номер заказа:',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.orderNumber,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    // const Spacer(),
                    // Text(
                    //   formatDateWithTime(widget.date, 'ru'),
                    //   style:
                    //       TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    // ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Дата заказа:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(widget.date)
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Сумма заказа:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${widget.sumOrder}₸',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Категория:',
                //       style:
                //           TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                //     ),
                //     Text(
                //       '${widget.provider_name}',
                //       style:
                //           TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                //     )
                //   ],
                // ),
                // const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _getStatusText(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: _orderColor(),
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                    if (_isCancelled)
                      const Text(
                        'Заказ успешно отменен',
                        style: TextStyle(color: Colors.red),
                      )
                    else if (widget.status == OrderStatus.confirmed)
                      ElevatedButton(
                        onPressed: () async {
                          var userProvider = context.read<UserProvider>();

                          SetStatusRequest setStatusRequest = SetStatusRequest(
                            uIDOrder: widget.orderID,
                            user: userProvider.user?.phoneNumber ?? "",
                            status: '09',
                          );
                          bool success =
                              await setStatus(setStatusRequest, context);
                          if (success) {
                            setState(() {
                              _isCancelled = true;
                              widget.refresh();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Отменить заказ',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
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
              content: "Не удалось отменить заказ",
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
          widget.refresh();
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
    switch (widget.status) {
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
    switch (widget.status) {
      case OrderStatus.confirmed:
        return AppColors.primaryColor;
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
