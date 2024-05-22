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
  List<PersistentShoppingCartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    getGoods(widget.catId ?? "");
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    setState(() {
      cartItems =
          (cartData['cartItems'] ?? []) as List<PersistentShoppingCartItem>;
    });
  }

  Future<GoodsResponse?> getGoods(String catId) async {
    try {
      var res = await GoodsSerVice().getGoods(catId);

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

  void addToCart(Goods goods) async {
    await PersistentShoppingCart().addToCart(PersistentShoppingCartItem(
      productId: goods.nomenklaturaKod ?? "",
      productName: goods.nomenklatura ?? "",
      unitPrice: goods.price ?? 0.0,
      quantity: 1,
      productThumbnail: goods.photo,
      productDetails: {
        "nomenklatura": goods.nomenklatura,
        "nomenklaturaKod": goods.nomenklaturaKod,
        "producer": goods.producer,
        "step": goods.step,
        "count": goods.count,
      },
      // Начальное количество товара 1
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

  void showProductDetails(Goods goods) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(goods.nomenklatura ?? ''),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (goods.photo != null)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.network(
                  goods.photo!,
                  width: 160,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Поставщик: ${goods.kontragent ?? ""}'),
                  const SizedBox(height: 4),
                  Text('Цена: ${goods.price?.toInt()}₸/кг'),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Закрыть'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(widget.title ?? "Товары"),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: appBarBack(context),
        actions: [
          IconButton(
            onPressed: () {
              // Get total number of items in the cart
              Navigator.pushNamed(context, "/cart");
              // Navigate to cart screen or do something with cart
            },
            iconSize: 32,
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined, color: Colors.green,),
                Positioned(
                  top: -2,
                  right: -1,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: !isLoading
          ? goodsResponse != null
              ? Container(
                  color: Colors.white, // Устанавливаем белый фон для списка
                  padding: const EdgeInsets.all(1.0),
                  child: (goodsResponse?.goods ?? []).isNotEmpty
                      ? ListView.builder(
                          itemCount: goodsResponse!.goods!.length,
                          itemBuilder: (context, index) {
                            Goods goods = goodsResponse!.goods![index];
                            bool isInCart = cartItems.any(
                                (item) => item.productId == goods.nomenklaturaKod);
                            return Card(
                              color: Colors.white, // Устанавливаем белый фон для карточки
                              child: ListTile(
                                onTap: () => showProductDetails(goods),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(goods.photo ?? ""),
                                ),
                                title: Text(goods.nomenklatura ?? ''),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Поставщик: ${goods.kontragent ?? ""}'),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Цена: ${goods.price?.toInt()}₸/кг',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!isInCart)
                                      IconButton(
                                        icon: const Icon(Icons.add_shopping_cart, color: Colors.green,),
                                        onPressed: () {
                                          addToCart(goods);
                                        },
                                      ),
                                    if (isInCart)
                                      IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline_rounded, color: Colors.red,),
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
    );
  }
}
