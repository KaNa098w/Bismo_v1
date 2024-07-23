import 'dart:developer';
import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bismo/core/models/catalog/search.dart';
import 'package:bismo/core/services/search_service.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:bismo/app/catalog/goods/goods_view.dart' as mobile;

class SearchCatalogView extends StatefulWidget {
  final String? title;
  final String query;

  const SearchCatalogView({
    Key? key,
    this.title,
    required this.query,
  }) : super(key: key);

  @override
  State<SearchCatalogView> createState() => _SearchCatalogViewState();
}

class _SearchCatalogViewState extends State<SearchCatalogView> {
  final SearchService _searchService = SearchService();
  List<SearchResultItems>? _searchResults;
  bool _isLoadingResults = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults(widget.query);
  }

  Future<void> _fetchSearchResults(String query) async {
    try {
      final results = await _searchService.getGoods(query);
      setState(() {
        _searchResults = results;
        _isLoadingResults = false;
      });
      // Логирование данных для диагностики
      if (results != null) {
        for (var item in results) {
          print(
              'Item: ${item.name}, cateId: ${item.cateId}, group: ${item.group}');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingResults = false;
      });
    }
  }

  void showProductDetails(SetOrderGoods goods) {
    int quantity = 0;

    void increment() {
      setState(() {
        quantity++;
      });
    }

    void decrement() {
      if (quantity > 0) {
        setState(() {
          quantity--;
        });
      }
    }
  }

  void _fetchGroupDetails(String cateId) {
    try {
      final SearchResultItems? item = _searchResults?.firstWhere(
        (item) => item.cateId == cateId,
      );

      if (item != null) {
        SetOrderGoods good = SetOrderGoods(
          nomenklatura: item.name,
          nomenklaturaKod: item.cateName,
          price: 100,
          photo: item.cateName,
          kontragent: item.name,
          comment: null,
          basketCount: 5,
        );

        showProductDetails(good);
      } else {
        print("Продукт с cateId: $cateId не найден.");
      }
    } catch (e) {
      print('Error fetching group details: $e');
    }
  }

  void _onSearchResultTap(SearchResultItems item) {
    final cateId = item.cateId ?? ''; // Использование cateId вместо catId
    print('Tapped item: ${item.name}, cateId: $cateId');
    print('Item details: $item'); // Логирование всего объекта для диагностики

    if (cateId.isNotEmpty) {
      if (item.group == false) {
        // _fetchGroupDetails(
        //     cateId); // Выполняем запрос с cateId и переходим в GoodsView
        Navigator.pushNamed(
          context,
          '/product_goods',
          arguments: GoodsArguments(
            item.cateName ?? '',
            item.cateId ?? '',
            item.name ?? '',
            0,
            item.code ?? '',
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => mobile.GoodsView(
              title: item.name ?? '',
              catId: cateId, // Использование cateId вместо catId
            ),
          ),
        );
      }
    } else {
      print('Error: cateId is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? 'Результаты поиска',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
        ),
      ),
      body: _isLoadingResults
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Error',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _fetchSearchResults(widget.query),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _searchResults == null || _searchResults!.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.separated(
                      itemCount: _searchResults!.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults![index];
                        return ListTile(
                          title: Text(item.name ?? 'No Name'),
                          subtitle: Text(item.cateName ?? 'No Category'),
                          // leading: Container(
                          //   width: 50,
                          //   height: 50,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   child: CachedNetworkImage(
                          //     imageUrl: item.cateName ?? "",
                          //     placeholder: (context, url) =>
                          //         const CircularProgressIndicator(),
                          //     errorWidget: (context, url, error) => Image.asset(
                          //       'assets/images/no_image.png',
                          //     ),
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          trailing: item.group == false
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Количество: ${item.quantity ?? 0}'),
                                  ],
                                )
                              : const Icon(Icons.arrow_forward),
                          onTap: () => _onSearchResultTap(item),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
    );
  }
}
