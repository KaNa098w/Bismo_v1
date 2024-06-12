import 'dart:developer';
import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/app_bar_back.dart';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:bismo/core/presentation/widgets/custom_empty_widget.dart';
import 'package:bismo/core/services/goods_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GoodsView extends StatefulWidget {
  final String? title;
  final String? catId;
  final String? kontragent;
  final int? price;
  final String? nomenklaturaKod;

  const GoodsView(
      {Key? key,
      this.title,
      this.catId,
      this.kontragent,
      this.price,
      this.nomenklaturaKod})
      : super(key: key);

  @override
  State<GoodsView> createState() => _GoodsViewState();
}

class _GoodsViewState extends State<GoodsView> {
  TextEditingController searchController = TextEditingController();

  GoodsResponse? goodsResponse;
  bool isLoading = true;
  List<PersistentShoppingCartItem> cartItems = [];
  List<Goods> filteredGoods = [];
  int currentQuantity = 0;
  List<String> productImages = [];

  @override
  void initState() {
    super.initState();
    _initializeHive();
    _fetchGoods(widget.catId ?? "");
    searchController.addListener(_filterGoods);
  }

  Future<void> _initializeHive() async {
    await Hive.openBox('shopping_cart'); // Открытие коробки
    _loadCartItems();
  }

  @override
  void dispose() {
    searchController.removeListener(_filterGoods);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCartItems() async {
    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    setState(() {
      cartItems =
          (cartData['cartItems'] ?? []) as List<PersistentShoppingCartItem>;
    });
  }

  void _filterGoods() {
    if (goodsResponse == null) return;

    String query = searchController.text.toLowerCase();
    setState(() {
      filteredGoods = goodsResponse!.goods!.where((goods) {
        return goods.nomenklatura?.toLowerCase().contains(query) ?? false;
      }).toList();
    });
  }

  Future<void> _fetchGoods(String catId) async {
    setState(() {
      isLoading = true;
    });

    try {
      GoodsResponse? res = await getGoods(catId);
      setState(() {
        goodsResponse = res;
        filteredGoods = res?.goods ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching goods: $e");
    }
  }

  Future<GoodsResponse?> getGoods(String catId) async {
    try {
      var res = await GoodsService().getGoods(catId);
      return res;
    } on DioException catch (e) {
      log(e.toString());
      return null;
    }
  }

  void addToCart(
      BuildContext context, SetOrderGoods goods, int quantity) async {
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

  void removeFromCart(Goods goods) async {
    await PersistentShoppingCart().removeFromCart(goods.nomenklaturaKod ?? "");
    _loadCartItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Товар удален из корзины'),
      backgroundColor: Colors.red,
      duration: Duration(milliseconds: 500),
    ));
  }

  SetOrderGoods convertToSetOrderGoods(Goods goods) {
    return SetOrderGoods(
      nomenklatura: goods.nomenklatura,
      nomenklaturaKod: goods.nomenklaturaKod,
      count: int.tryParse(goods.count ?? '0'),
      price: goods.price?.toDouble(),
      optPrice: goods.optPrice?.toDouble(),
      producer: goods.kontragent,
      kontragent: goods.kontragent,
      step: goods.step,
      newProduct: goods.newProduct,
      photo: goods.photo,
      catId: goods.catId,
      oldPrice: goods.oldPrice?.toDouble(),
      newsPhoto: goods.newsPhoto,
      comment: '',
      basketCount: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
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
        leading: appBarBack(context),
      ),
      body: !isLoading
          ? goodsResponse != null
              ? Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: filteredGoods.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredGoods.length,
                          itemBuilder: (context, index) {
                            Goods goods = filteredGoods[index];
                            bool isInCart = cartItems.any((item) =>
                                item.productId == goods.nomenklaturaKod);
                            return Card(
                              color: Colors.white,
                              child: ListTile(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/product_goods',
                                  arguments: GoodsArguments(
                                    goods.nomenklatura ?? '',
                                    goods.catId ?? '',
                                    goods.kontragent ?? '',
                                    goods.price ?? 0,
                                    goods.nomenklaturaKod ?? '',
                                  ),
                                ),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: goods.photo ?? "",
                                    cacheManager: null, // Disable caching
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.network(
                                      'https://images.satu.kz/197787004_w200_h200_pomада-для-губ.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  goods.nomenklatura ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Поставщик: '),
                                        Text(
                                          goods.kontragent ?? "",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Text('Цена: '),
                                        Text(
                                          '${goods.price?.toInt()}₸/кг',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!isInCart)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_shopping_cart,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          addToCart(
                                            context,
                                            convertToSetOrderGoods(goods),
                                            1,
                                          );
                                        },
                                      ),
                                    if (isInCart)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          removeFromCart(goods);
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const CustomEmpty(),
                )
              : const CustomEmpty()
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/cart");
          },
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Далее',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
