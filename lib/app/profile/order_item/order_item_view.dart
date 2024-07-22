import 'dart:developer';

import 'package:bismo/core/colors.dart';
import 'package:bismo/core/models/order/detalization_order_response.dart';
import 'package:bismo/core/models/order/get_my_order_list_response.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details.dart';
import 'package:bismo/core/presentation/widgets/app_back_button.dart';
import 'package:bismo/core/presentation/widgets/custom_error_widget.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/order.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderItemView extends StatefulWidget {
  final String? title;
  final JSONBody? orderItem;
  const OrderItemView({Key? key, this.title, this.orderItem}) : super(key: key);

  @override
  State<OrderItemView> createState() => _OrderItemViewState();
}

class _OrderItemViewState extends State<OrderItemView> {
  DetalizationOrderResponse? orderItemResponse;
  bool isLoading = true;
  double categoryTotalSum = 0.0; // Добавлено

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var userProvider = context.read<UserProvider>();
      getOrder(userProvider.user?.phoneNumber ?? "",
          widget.orderItem?.uIDOrder ?? "");
    });
  }

  Future<DetalizationOrderResponse?> getOrder(
      String phoneNumber, String orderId) async {
    try {
      var res =
          await OrderService().getDetalizationsOrder(phoneNumber, orderId);

      setState(() {
        orderItemResponse = res;
        isLoading = false;
        categoryTotalSum = calculateCategoryTotalSum(res); // Расчет суммы
      });

      return res;
    } on DioException catch (e) {
      log(e.toString());

      setState(() {
        isLoading = false;
      });

      return null;
    }
  }

  double calculateCategoryTotalSum(DetalizationOrderResponse? order) {
    // Реализуйте расчет суммы товаров внутри категории
    double totalSum = 0.0;
    if (order != null && order.factSum != null) {
      for (var item in order.goods!) {
        totalSum += (item.price ?? 0) * (item.basketCount ?? 0);
      }
    }
    return totalSum;
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (isLoading) {
      body = const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: Center(
              child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          )),
        ),
      );
    } else if (orderItemResponse == null) {
      body = const CustomErrorWidget();
    } else {
      body = OrderDetailsPage(
        order: orderItemResponse,
        categoryTotalSum: categoryTotalSum, // Передача рассчитанной суммы
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: const Text('Детали заказа'),
        ),
        body: Container(
          color: AppColors.cardColor,
          child: body,
        ),
      ),
    );
  }
}
