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
  int currentQuantity = 0;

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
            // Use StatefulBuilder to manage state
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 450,
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
                              addToCart(goods, quantity);
                              setState(
                                () {
                                  currentQuantity = quantity;
                                },
                              );
                             
                              Navigator.pop(context);
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
                            child: Image.network(
                              goods.photo!,
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
                          Icon(Icons.star, color: Colors.amber, size: 18),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: appBarTitle(widget.title ?? "Товары"),
        title: TextField(
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
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // Get total number of items in the cart
        //       Navigator.pushNamed(context, "/cart");
        //       // Navigate to cart screen or do something with cart
        //     },
        //     iconSize: 32,
        //     icon: Stack(
        //       children: [
        //         const Icon(
        //           Icons.shopping_cart_outlined,
        //           color: Colors.green,
        //         ),
        //         Positioned(
        //           top: -2,
        //           right: -1,
        //           child: CircleAvatar(
        //             radius: 8,
        //             backgroundColor: Colors.red,
        //             child: Text(
        //               cartItems.length.toString(),
        //               style: const TextStyle(fontSize: 11, color: Colors.white),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ],
      ),
      body: !isLoading
          ? goodsResponse != null
              ? Container(
                  color: Colors.white, // Устанавливаем белый фон для списка
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: (goodsResponse?.goods ?? []).isNotEmpty
                      ? ListView.builder(
                          itemCount: goodsResponse!.goods!.length,
                          itemBuilder: (context, index) {
                            Goods goods = goodsResponse!.goods![index];
                            bool isInCart = cartItems.any((item) =>
                                item.productId == goods.nomenklaturaKod);
                            return Card(
                              color: Colors.white,
                              child: ListTile(
                                onTap: () => showProductDetails(goods),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(goods.photo ?? ""),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // leading: CircleAvatar(
                                //   backgroundImage:
                                //       NetworkImage(goods.photo ?? ""),
                                // ),
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
                                    //Text('$currentQuantity', style: TextStyle(fontSize: 16),),

                                    if (!isInCart)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_shopping_cart,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          addToCart(goods, 1);
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
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
