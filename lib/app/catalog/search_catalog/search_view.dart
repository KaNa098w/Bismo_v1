import 'dart:developer';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bismo/core/models/catalog/search.dart';
import 'package:bismo/core/services/search_service.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:bismo/app/catalog/goods/goods_view.dart' as mobile;

class SearchCatalogView extends StatefulWidget {
  final String? title;
  final String query;

  const SearchCatalogView({Key? key, this.title, required this.query})
      : super(key: key);

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

  void addToCart(Goods goods, int quantity) async {
    await PersistentShoppingCart().addToCart(PersistentShoppingCartItem(
      productId: goods.nomenklaturaKod ?? "",
      productName: goods.nomenklatura ?? "",
      unitPrice: goods.price ?? 0.0,
      quantity: quantity,
      productThumbnail: goods.photo,
      productDetails: {
        "nomenklatura": goods.nomenklatura,
        "nomenklaturaKod": goods.nomenklaturaKod,
        "producer": goods.producer,
        "step": goods.step,
        "count": goods.count,
      },
    ));
    _loadCartItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Товар добавлен в корзину'),
      backgroundColor: Colors.green,
      duration: Duration(milliseconds: 500),
    ));
  }

  Future<void> _loadCartItems() async {
    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    setState(() {
      // cartItems =
      //     (cartData['cartItems'] ?? []) as List<PersistentShoppingCartItem>;
    });
  }

  void showProductDetails(Goods goods) {
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 500,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                          ),
                          InkWell(
                            onTap: () {
                              if (quantity > 0) {
                                addToCart(goods, quantity);
                                setState(
                                  () {
                                    // currentQuantity = quantity;
                                  },
                                );

                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Количество должно быть больше нуля'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(milliseconds: 500),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Готова',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (goods.photo != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: goods.photo!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Image.network(
                                'https://images.satu.kz/197787004_w200_h200_pomада-для-губ.jpg',
                              ),
                              width: 180,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Text(
                        goods.nomenklatura ?? '',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () {
                                if (quantity > 0) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color:
                                      quantity > 0 ? Colors.blue : Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.remove,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text("$quantity"),
                          const SizedBox(width: 20),
                          Center(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${goods.price?.toInt()}₸/кг',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            goods.kontragent ?? "",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(width: 50),
                          Text(
                            "Сумма: ${(quantity * (goods.price ?? 0)).toStringAsFixed(2)}₸",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star,
                              color: Color.fromARGB(255, 94, 94, 93), size: 18),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Комментария, пожелания',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _fetchGroupDetails(String cateId) {
    try {
      final SearchResultItems? item = _searchResults?.firstWhere(
        (item) => item.cateId == cateId,
      );

      if (item != null) {
        Goods good = Goods(
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
        _fetchGroupDetails(
            cateId); // Выполняем запрос с cateId и переходим в GoodsView
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
        title: Text(widget.title ?? 'Результаты поиска'),
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
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: item.cateName ?? "",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Image.network(
                                'https://images.satu.kz/197787004_w200_h200_pomада-для-губ.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
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
