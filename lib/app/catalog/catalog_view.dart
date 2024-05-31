// lib/catalog_view.dart
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
  const CatalogView({Key? key, this.title}) : super(key: key);

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
    getCategories();
  }

  Future<CategoryResponse?> getCategories() async {
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
              borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
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
                ? ListView.builder(
                    itemCount: (categoryResponse?.body ?? []).length,
                    itemBuilder: (context, index) {
                      final category = categoryResponse?.body![index];
                      return CategoryTile(
                        imageLink: category?.photo ?? "",
                        label: category?.catName ?? "",
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/goods",
                            arguments: GoodsArguments(
                              category?.catName ?? "",
                              category?.catId ?? "",
                            ),
                          );
                        },
                      );
                    },
                  )
                : const CustomEmpty(),
          )
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
