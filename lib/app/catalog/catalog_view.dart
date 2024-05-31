import 'dart:developer';
import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/app/catalog/search_catalog/search_view.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/app_bar_back.dart';
import 'package:bismo/core/models/catalog/category.dart';
import 'package:bismo/core/presentation/widgets/custom_empty_widget.dart';
import 'package:bismo/core/presentation/widgets/custom_error_widget.dart';
import 'package:bismo/core/services/catalog_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bismo/core/presentation/widgets/category_tile.dart';

class CatalogView extends StatefulWidget {
  final String? title;
  final String? catId;

  const CatalogView({Key? key, this.title, this.catId}) : super(key: key);

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  late GlobalKey<NavigatorState> navigatorKey;

  CategoryResponse? categoryResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCategories(widget.catId);
  }

  Future<CategoryResponse?> getCategories(String? catId) async {
    try {
      var res = await CatalogService().getCategories(catId ?? '');

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

  void onCategorySelected(String catId) async {
    setState(() {
      isLoading = true;
    });

    var res = await getCategories(catId);

    if (res?.body?.isEmpty ?? true) {
      Navigator.pushNamed(
        context,
        "/goods",
        arguments: GoodsArguments(categoryResponse?.body?[0].catName ?? "",
            categoryResponse?.body?[0].catId ?? ""),
      );
    } else {
      setState(() {
        categoryResponse = res;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onSubmitted: (query) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchCatalogView(initialQuery: query),
              ),
            );
          },
          decoration: InputDecoration(
            hintText: 'Поиск товаров',
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor, width: 2),
            ),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: !isLoading
          ? categoryResponse != null
              ? Container(
                  child: (categoryResponse?.body ?? []).isNotEmpty
                      ? GridView.count(
                          crossAxisCount: 3,
                          children: List.generate(
                            ((categoryResponse?.body) ?? []).length,
                            (index) {
                              return Expanded(
                                child: CategoryTile(
                                  imageLink:
                                      categoryResponse?.body?[index].photo ??
                                          "",
                                  label:
                                      categoryResponse?.body?[index].catName ??
                                          "",
                                  onTap: () {
                                    onCategorySelected(
                                        categoryResponse?.body?[index].catId ??
                                            "");
                                  },
                                ),
                              );
                            },
                          ),
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
                  ),
                ),
              ),
            ),
    );
  }
}
