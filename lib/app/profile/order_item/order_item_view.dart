import 'dart:developer';

import 'package:bismo/core/colors.dart';
import 'package:bismo/core/models/order/detalization_order_response.dart';
import 'package:bismo/core/models/order/get_my_order_list_response.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details.dart';
import 'package:bismo/core/presentation/components/orders_comp/tab_all.dart';
import 'package:bismo/core/presentation/widgets/app_back_button.dart';
import 'package:bismo/core/presentation/widgets/custom_circular_loader.dart';
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

      // log(res?.toJson().toString() ?? "");

      setState(() {
        orderItemResponse = res;
        isLoading = false;
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
      body = OrderDetailsPage(order: orderItemResponse);
    }

    // !isLoading
    //     ? orderItemResponse != null
    //         ? Container(
    //             child: (orderItemResponse?.body ?? []).isNotEmpty
    //                 ? GridView.count(
    //                     crossAxisCount: 3,
    //                     children: List.generate(
    //                         ((orderItemResponse?.body) ?? []).length, (index) {
    //                       return CategoryTile(
    //                         imageLink:
    //                             orderItemResponse?.body?[index].photo ?? "",
    //                         label:
    //                             orderItemResponse?.body?[index].catName ?? "",
    //                         onTap: () {
    //                           Navigator.pushNamed(
    //                             context,
    //                             "/goods",
    //                             arguments: GoodsArguments(
    //                                 orderItemResponse?.body?[index].catName ??
    //                                     "",
    //                                 orderItemResponse?.body?[index].catId ??
    //                                     ""),
    //                           );
    //                         },
    //                       );
    //                     }),
    //                   )
    //                 : const CustomEmpty())
    //     : const SizedBox(child: CustomErrorWidget())
    // : const Center(
    //     child: SizedBox(
    //       height: 50.0,
    //       width: 50.0,
    //       child: Center(
    //           child: CircularProgressIndicator(
    //         color: AppColors.primaryColor,
    //       )),
    //     ),
    //   );
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
