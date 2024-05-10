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

  CategoryResponse? categoryResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCategories(widget.catId ?? "");
  }

  Future<GoodsResponse?> getCategories(String catId) async {
    try {
      var res = await GoodsSerVice().getCategories(catId);

      // log(res?.toJson().toString() ?? "");

      setState(() {
        categoryResponse = res;
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
          ? categoryResponse != null
              ? Container(
                  child: (categoryResponse?.body ?? []).isNotEmpty
                      ? GridView.count(
                          crossAxisCount: 3,
                          children: List.generate(
                              ((categoryResponse?.body) ?? []).length, (index) {
                            return CategoryTile(
                              imageLink:
                                  categoryResponse?.body?[index].photo ?? "",
                              label:
                                  categoryResponse?.body?[index].catName ?? "",
                              onTap: () {},
                            );
                          }),
                        )
                      : const CustomEmpty())
              : const SizedBox(child: CustomErrorWidget())
          : const Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: Center(
                    child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                )),
              ),
            ),
    );
  }
}
