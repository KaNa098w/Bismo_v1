import 'dart:developer';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/app_bar_back.dart';
import 'package:bismo/core/helpers/app_bar_title.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:bismo/core/presentation/widgets/custom_empty_widget.dart';
import 'package:bismo/core/services/goods_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

class SearchCatalogView extends StatefulWidget {
  final String initialQuery;
  const SearchCatalogView({Key? key, this.initialQuery = ''}) : super(key: key);
  

  @override
  State<SearchCatalogView> createState() => _SearchCatalogViewState();
}

class _SearchCatalogViewState extends State<SearchCatalogView> {
  late GlobalKey<NavigatorState> navigatorKey;
  TextEditingController searchController = TextEditingController();

    @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Поиск товаров',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ),
      body: Center(
        child: Text('Результаты поиска для: ${searchController.text}'),
      ),
    );
  }
    
  }

