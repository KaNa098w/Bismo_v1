import 'dart:developer';
import 'package:bismo/app/catalog/catalog_arguments.dart';
import 'package:bismo/app/catalog/search_catalog/search_view.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/models/catalog/category.dart';
import 'package:bismo/core/models/catalog/search.dart';
import 'package:bismo/core/presentation/widgets/custom_empty_widget.dart';
import 'package:bismo/core/presentation/widgets/custom_error_widget.dart';
import 'package:bismo/core/services/catalog_service.dart';
import 'package:bismo/core/services/search_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bismo/core/presentation/widgets/category_tile.dart';
import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/app/catalog/goods/goods_view.dart' as mobile;

class CatalogView extends StatefulWidget {
  final String? title;
  final String? catId;

  const CatalogView({Key? key, this.title, this.catId}) : super(key: key);

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  CategoryResponse? categoryResponse;
  bool isLoading = true;

  final SearchService _searchService = SearchService();

  @override
  void initState() {
    super.initState();
    if (widget.catId != null) {
      _loadCategories(widget.catId!);
    }
  }

  Future<void> _loadCategories(String catId) async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await CatalogService().getCategories(catId);
      setState(() {
        categoryResponse = response;
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onCategorySelected(String name, String catId, bool haveCategory) {
    if (haveCategory) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CatalogView(
            title: name,
            catId: catId,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => mobile.GoodsView(
            title: name,
            catId: catId,
          ),
        ),
      );
    }
  }

void _onSearchSubmitted(String query) async {
  if (query.isNotEmpty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchCatalogView(query: query), // Передача поискового запроса
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.catId == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        title: TextField(
          onSubmitted: _onSearchSubmitted,
          decoration: InputDecoration(
            hintText: 'Поиск товаров',
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : categoryResponse != null
              ? categoryResponse!.body!.isNotEmpty
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio:
                            0.7, // Изменяем аспектное соотношение для лучшей адаптивности
                      ),
                      itemCount: categoryResponse!.body!.length,
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          imageLink: categoryResponse!.body![index].photo ?? "",
                          label: categoryResponse!.body![index].catName ?? "",
                          onTap: () {
                            _onCategorySelected(
                              categoryResponse!.body![index].catName ?? "",
                              categoryResponse!.body![index].catId ?? "",
                              categoryResponse!.body![index].haveCategory ??
                                  false,
                            );
                          },
                        );
                      },
                    )
                  : const CustomEmpty()
              : const CustomErrorWidget(),
    );
  }
}
