import 'dart:developer';
import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/models/catalog/category.dart';
import 'package:bismo/core/presentation/widgets/custom_empty_widget.dart';
import 'package:bismo/core/presentation/widgets/custom_error_widget.dart';
import 'package:bismo/core/services/catalog_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bismo/core/presentation/widgets/category_tile.dart';

class CatalogView extends StatefulWidget {
  final String? title;
  const CatalogView({Key? key, this.title}) : super(key: key);

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  late GlobalKey<NavigatorState> navigatorKey;

  GoodsResponse? categoryResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future<GoodsResponse?> getCategories() async {
    try {
      var res = await CatalogService().getCategories('');

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
    return !isLoading
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
                            label: categoryResponse?.body?[index].catName ?? "",
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/goods",
                                arguments: GoodsArguments(
                                    categoryResponse?.body?[index].catName ??
                                        "",
                                    categoryResponse?.body?[index].catId ?? ""),
                              );
                            },
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
          );
  }
}
