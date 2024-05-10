import 'dart:developer';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/app_bar_back.dart';
import 'package:bismo/core/helpers/app_bar_title.dart';
import 'package:bismo/core/models/catalog/category.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:bismo/core/presentation/widgets/category_tile.dart';
import 'package:bismo/core/presentation/widgets/custom_empty_widget.dart';
import 'package:bismo/core/presentation/widgets/custom_error_widget.dart';
import 'package:bismo/core/services/catalog_service.dart';
import 'package:bismo/core/services/goods_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';

class GoodsView extends StatefulWidget {
  final String? title;
  final String? catId;
  const GoodsView({Key? key, this.title, this.catId}) : super(key: key);

  @override
  State<GoodsView> createState() => _GoodsViewState();
}

class _GoodsViewState extends State<GoodsView> {
  late GlobalKey<NavigatorState> navigatorKey;

  GoodsResponse? goodsResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getGoods(widget.catId ?? "");
  }

  Future<GoodsResponse?> getGoods(String catId) async {
    try {
      var res = await GoodsSerVice().getGoods(catId);

      // log(res?.toJson().toString() ?? "");

      setState(() {
        goodsResponse = res;
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
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(widget.title ?? "Товары"),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: appBarBack(context),
      ),
      body: !isLoading
          ? goodsResponse != null
              ? Container(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: goodsResponse!.goods!.length,
                    itemBuilder: (context, index) {
                      Goods goods = goodsResponse!.goods![index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(goods.photo ??
                                ""), // Используйте ссылку на фото товара, если доступно
                          ),
                          title: Text(goods.nomenklatura ?? ''),
                          subtitle: Text('Цена: ${goods.price.toString()}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              // cart.addToCart(productId: goods.id, unitPrice: goods.price, quantity: 1);
                            },
                          ),
                          onTap: () {
                            // Подробная информация о товаре или действия с товаром
                          },
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text('Нет товаров'),
                )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cart'); // Переход к странице корзины
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
