import 'dart:developer';
import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/app/catalog/goods/media/photo_upload_helped.dart';
import 'package:bismo/app/catalog/goods/media/video_upload_helper.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/app_bar_back.dart';
import 'package:bismo/core/helpers/app_bar_title.dart';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:bismo/core/presentation/widgets/custom_empty_widget.dart';
import 'package:bismo/core/services/goods_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GoodsView extends StatefulWidget {
  final String? title;
  final String? catId;
  const GoodsView({Key? key, this.title, this.catId}) : super(key: key);

  @override
  State<GoodsView> createState() => _GoodsViewState();
}

class _GoodsViewState extends State<GoodsView> {
  late GlobalKey<NavigatorState> navigatorKey;
  TextEditingController searchController = TextEditingController();

  GoodsResponse? goodsResponse;
  bool isLoading = true;
  List<PersistentShoppingCartItem> cartItems = [];
  List<Goods> filteredGoods = [];
  int currentQuantity = 0;

  @override
  void initState() {
    super.initState();
    _fetchGoods(widget.catId ?? "");
    _loadCartItems();
    searchController.addListener(_filterGoods);
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

    Future<void> requestStoragePermission(Function onPermissionGranted) async {
      if (await Permission.storage.request().isGranted) {
        onPermissionGranted();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Доступ к хранилищу не предоставлен'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
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
                    maxHeight: 550,
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
                                    currentQuantity = quantity;
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
                              'Готово',
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
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  requestStoragePermission(() {
                                    uploadPhoto(
                                      context,
                                      '7783734209',
                                      goods.nomenklaturaKod ?? "",
                                      widget.catId ?? "",
                                      () {
                                        setState(
                                            () {}); // Обновление состояния внутри диалога
                                        _fetchGoods(widget.catId ??
                                            ""); // Обновление данных на странице
                                      },
                                      (newPhotoUrl) {
                                        setState(() {
                                          goods.photo =
                                              newPhotoUrl; // Обновление URL изображения
                                        });
                                      },
                                    );
                                  });
                                },
                                icon: const Icon(Icons.upload_file,
                                    color: Colors.blue),
                                label: const Text(
                                  'Загрузить фото',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/media_delete_page',
                                    arguments: GoodsArguments(
                                        'Медиафайлы',
                                        goods.nomenklaturaKod ?? ''),
                                  );
                                },
                                icon: const Icon(Icons.delete_outline_rounded,
                                    color: Colors.red),
                                label: const Text(
                                  'Удалить',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
                          TextButton.icon(
                            onPressed: () {
                              requestStoragePermission(() {
                                uploadVideo(
                                  context,
                                  '7783734209',
                                  goods.nomenklaturaKod ?? "",
                                  widget.catId ?? "",
                                  () {
                                    setState(
                                        () {}); // Обновление состояния внутри диалога
                                    _fetchGoods(widget.catId ??
                                        ""); // Обновление данных на странице
                                  },
                                  (newPhotoUrl) {
                                    setState(() {
                                      goods.photo =
                                          newPhotoUrl; // Обновление URL изображения
                                    });
                                  },
                                );
                              });
                            },
                            icon: const Icon(Icons.video_chat_outlined,
                                color: Colors.blue),
                            label: const Text(
                              'Загрузить видео',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      )
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
                                onTap: () => showProductDetails(goods),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: goods.photo ?? "",
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
