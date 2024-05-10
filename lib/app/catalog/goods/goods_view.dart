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
        title: appBarTitle(widget.title ?? ""),
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
                      return ListTile(
                        title: Text(goods.nomenklatura ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Цена: ${goods.price.toString()}'),
                            Text('Количество: ${goods.count.toString()}'),
                            Text(
                                'Производитель: ${goods.producer ?? "Неизвестно"}'),
                            Text(
                                'Контрагент: ${goods.kontragent ?? "Неизвестно"}'),
                            Text('Шаг: ${goods.step ?? "Не указан"}'),
                            Text(
                                'Новый продукт: ${goods.newProduct == 1 ? "Да" : "Нет"}'),
                            Text(
                                'Старая цена: ${goods.oldPrice ?? "Не указана"}'),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const CustomEmpty()
          : const Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
    );
  }
}
