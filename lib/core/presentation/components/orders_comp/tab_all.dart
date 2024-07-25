import 'dart:convert';
import 'dart:developer';
import 'package:bismo/app/profile/order_item/order_item_arguments.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/models/order/get_my_order_list_response.dart';
import 'package:bismo/core/presentation/components/orders_comp/dummy_order_status.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_preview_tile.dart';
import 'package:bismo/core/presentation/widgets/custom_circular_loader.dart';
import 'package:bismo/core/presentation/widgets/custom_empty_widget.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/order.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllTab extends StatefulWidget {
  const AllTab({Key? key}) : super(key: key);

  @override
  _AllTabState createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  List<JSONBody> items = [];
  int page = 0;
  bool hasMore = true;
  bool isLoading = false;
  bool isError = false;
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        fetch();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refresh();
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future fetch() async {
    if (isLoading) return;
    isLoading = true;
    int limit = 12;
    var userProvider = context.read<UserProvider>();

    try {
      var result = await OrderService().getMyOrdersList(
          userProvider.user?.phoneNumber ?? "", (page + 1).toString());

      if (result != null) {
        final List<JSONBody> newItems = result.jSONBody ?? [];

        setState(() {
          page++;
          isLoading = false;

          if ((newItems.length) < limit) {
            hasMore = false;
          }

          items.addAll(newItems.map<JSONBody>((item) {
            return item;
          }));
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  Future refresh() async {
    setState(() {
      isLoading = false;
      isError = false;
      hasMore = true;
      page = 0;
      items.clear();
    });
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: refresh,
            child: (items.isNotEmpty || isLoading)
                ? ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    itemCount: items.length + 1,
                    itemBuilder: (context, index) {
                      if (index < items.length) {
                        final item = items[index];
                        return OrderPreviewTile(
                          order: item,
                          onTap: () async {
                            await Navigator.pushNamed(context, "/order_item",
                                arguments: OrderItemArguments(item));

                            refresh();
                          },
                          refresh: refresh,
                          orderID: item.uIDOrder ?? "",
                          orderNumber: item.number ?? "",
                          date: item.date ?? "",
                          status: _getStatus(item.status as int),
                          sumOrder: item.sumOrder ?? '',
                          provider_name: '',
                        );
                      } else {
                        return hasMore
                            ? const CustomCircularLoader()
                            : const SizedBox();
                      }
                    })
                : const CustomEmpty(),
          ),
        ),
      ],
    );
  }

  OrderStatus _getStatus(int status) {
    switch (status) {
      case 0:
        return OrderStatus.confirmed;
      case 1:
        return OrderStatus.processing;
      case 2:
        return OrderStatus.shipped;
      case 3:
        return OrderStatus.delivery;
      case 9:
        return OrderStatus.cancelled;
      default:
        return OrderStatus.unknown;
    }
  }
}
