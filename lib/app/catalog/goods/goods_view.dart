import 'dart:developer';
import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/app_bar_back.dart';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/widgets/custom_empty_widget.dart';
import 'package:bismo/core/presentation/widgets/custom_number_format.dart';
import 'package:bismo/core/providers/theme_provider.dart';
import 'package:bismo/core/services/goods_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  Map<String, int> quantities = {}; // Количество для каждого товара
  Map<String, TextEditingController> controllers =
      {}; // Контроллеры для каждого товара
  double totalAmount = 0.0; // Общая сумма выбранных товаров
  int totalQuantity = 0;
  int totalUniqueItems = 0; // Общее количество уникальных выбранных товаров
  String categoryClient = 'A';

  @override
  void initState() {
    super.initState();
    _initializeHive();
    searchController.addListener(_filterGoods);
  }

  Future<void> _initializeHive() async {
    await _loadCartItems();
    await _fetchGoods(widget.catId ?? "");
  }

  @override
  void dispose() {
    searchController.removeListener(_filterGoods);
    searchController.dispose();
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCartItems();
  }

  void _updateTotalAmount() {
    double newTotal = 0.0;
    int newTotalUniqueItems = 0;
    for (var goods in filteredGoods) {
      int quantity = quantities[goods.nomenklaturaKod ?? ""] ?? 0;
      if (quantity > 0 && (goods.calculation ?? true)) {
        newTotal +=
            (goods.price?.toDouble() ?? 0.0) * (goods.step ?? 1) * quantity;
        newTotalUniqueItems++;
      }
    }
    setState(() {
      totalAmount = newTotal;
      totalUniqueItems = newTotalUniqueItems;
    });
  }

  void _refreshGoodsQuantities() {
    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    List<PersistentShoppingCartItem> updatedCartItems =
        (cartData['cartItems'] ?? []) as List<PersistentShoppingCartItem>;

    setState(() {
      cartItems = updatedCartItems;
      for (var goods in filteredGoods) {
        quantities[goods.nomenklaturaKod ?? ""] = 0;
        for (var cartItem in updatedCartItems) {
          if (goods.nomenklaturaKod == cartItem.productId) {
            quantities[goods.nomenklaturaKod ?? ""] = cartItem.quantity;
            controllers[goods.nomenklaturaKod ?? ""]?.text =
                cartItem.quantity.toString();
            break;
          }
        }
      }
      _updateTotalAmount();
    });
  }

  Future<void> _loadCartItems() async {
    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    setState(() {
      cartItems =
          (cartData['cartItems'] ?? []) as List<PersistentShoppingCartItem>;
    });
    _refreshGoodsQuantities();
  }

  void _filterGoods() {
    if (goodsResponse == null) return;

    String query = searchController.text.toLowerCase();
    setState(() {
      filteredGoods = goodsResponse!.goods!.where((goods) {
        return goods.nomenklatura?.toLowerCase().contains(query) ?? false;
      }).toList();
      _updateTotalAmount();
    });
  }

  Future<void> _fetchGoods(String catId) async {
    setState(() {
      isLoading = true;
    });

    try {
      GoodsResponse? res = await getGoods(catId);
      Future.delayed(Duration.zero, () {
        setState(() {
          goodsResponse = res;
          filteredGoods = res?.goods ?? [];
          categoryClient = 'A'; // Store categoryClient value
          isLoading = false;

          // Initialize quantities and controllers for each goods
          for (var goods in filteredGoods) {
            quantities[goods.nomenklaturaKod ?? ""] = 0;
            controllers[goods.nomenklaturaKod ?? ""] =
                TextEditingController(text: "0");

            // Check if the goods is already in the cart and update quantity
            for (var cartItem in cartItems) {
              if (goods.nomenklaturaKod == cartItem.productId) {
                quantities[goods.nomenklaturaKod ?? ""] = cartItem.quantity;
                controllers[goods.nomenklaturaKod ?? ""]?.text =
                    cartItem.quantity.toString();
                break;
              }
            }
          }

          _updateTotalAmount();
        });
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

  void addToCart(BuildContext context, SetOrderGoods goods, int quantity,
      String parent) async {
    bool itemExists =
        cartItems.any((item) => item.productId == goods.nomenklaturaKod);

    if (itemExists) {
      // Если товар существует, удалите его
      await PersistentShoppingCart()
          .removeFromCart(goods.nomenklaturaKod ?? "");
    }

    await PersistentShoppingCart().addToCart(PersistentShoppingCartItem(
      productId: goods.nomenklaturaKod ?? "",
      productName: goods.nomenklatura ?? "",
      unitPrice: goods.price ?? 0.0,
      quantity: quantity,
      productThumbnail: goods.photo,
      productDetails: {
        "nomenklatura": goods.nomenklatura,
        "nomenklaturaKod": goods.nomenklaturaKod,
        "producer": goods.kontragent,
        "step": goods.step,
        "count": goods.count,
        "parent": parent,
      },
    ));
    _loadCartItems();
    _updateTotalAmount();
  }

  void removeFromCart(Goods goods) async {
    // Удаляем товар из корзины
    await PersistentShoppingCart().removeFromCart(goods.nomenklaturaKod ?? "");

    // Удаляем изображение из кэша
    if (goods.photo != null && goods.photo!.isNotEmpty) {
      await DefaultCacheManager().removeFile(goods.photo!);
    }

    // Обновляем корзину и общую сумму
    _loadCartItems();
    _updateTotalAmount();
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

  void _addToCartAndNavigate() {
    bool hasSelectedGoods = filteredGoods.any((goods) {
      int quantity = quantities[goods.nomenklaturaKod ?? ""] ?? 0;
      return quantity > 0;
    });

    if (!hasSelectedGoods) {
      showWarningDialog(context);
      return;
    }

    for (var goods in filteredGoods) {
      int quantity = quantities[goods.nomenklaturaKod ?? ""] ?? 0;
      if (quantity > 0) {
        addToCart(context, convertToSetOrderGoods(goods), quantity,
            goods.parent ?? "");
      }
    }

    showAlertDialog(
      context: context,
      barrierDismissible: true,
      title: "Уведомление",
      content: "Товар успешно добавлен в корзину.",
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () async {
            Navigator.pop(context);
            var tm = context.read<ThemeProvider>();
            tm.setNavIndex(3);
            await Navigator.pushNamed(context, "/");
          },
          textStyle: const TextStyle(color: AppColors.primaryColor),
          child: const Text("Перейти в корзину"),
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          textStyle: const TextStyle(color: AppColors.textBlack),
          child: const Text("Назад"),
        ),
      ],
    );
  }

  void showWarningDialog(BuildContext context) {
    showAlertDialog(
      context: context,
      barrierDismissible: true,
      title: "Предупреждение",
      content: "Пожалуйста, выберите товар перед продолжением.",
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          textStyle: const TextStyle(color: AppColors.textBlack),
          child: const Text("ОК"),
        ),
      ],
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
                            int quantity =
                                quantities[goods.nomenklaturaKod ?? ""] ?? 0;
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
                                    goods.price as int,
                                    goods.nomenklaturaKod ?? '',
                                  ),
                                ),
                                leading: Container(
                                  width: 150,
                                  height: 200, // Увеличьте высоту контейнера
                                  child: FittedBox(
                                    fit: BoxFit
                                        .cover, // Используйте BoxFit.cover для заполнения контейнера изображением
                                    child: SizedBox(
                                      width: 150,
                                      height: 250 *
                                          3 /
                                          4, // Установите правильное соотношение сторон 3х4
                                      child: CachedNetworkImage(
                                        imageUrl: goods.photo ?? "",
                                        cacheManager:
                                            null, // Отключить кэширование
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/no_image.png',
                                        ),
                                        fit: BoxFit
                                            .cover, // Используйте BoxFit.cover для заполнения контейнера изображением
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  goods.nomenklatura ?? '',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          goods.kontragent ?? "",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Text(
                                          'В упаковке: ',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                        Flexible(
                                          child: Text(
                                            quantity > 1
                                                ? '${goods.step}шт х $quantity'
                                                : '${goods.step}шт',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (quantity > 0)
                                      Row(
                                        children: [
                                          const Text(
                                            'Сумма: ',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Flexible(
                                            child: Text(
                                              (goods.price != null &&
                                                      goods.step != null)
                                                  ? '${CustomNumberFormat.format(goods.price! * goods.step! * quantity)}₸'
                                                  : '0₸',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      const SizedBox.shrink(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: goods.typePrice != 'A'
                                          ? goods.typePrice!.map((typePrice) {
                                              String formattedName = typePrice
                                                      .name
                                                      ?.replaceAllMapped(
                                                          RegExp(
                                                              r'(\d)(?=(\d{3})+(?!\d))'),
                                                          (Match m) =>
                                                              '${m[1]} ') ??
                                                  '0';
                                              String formattedPrice = typePrice
                                                  .price
                                                  .toString()
                                                  .replaceAllMapped(
                                                      RegExp(
                                                          r'(\d)(?=(\d{3})+(?!\d))'),
                                                      (Match m) => '${m[1]} ');
                                              String formattedCategory =
                                                  typePrice.category.toString();
                                              bool isBold = categoryClient ==
                                                  formattedCategory;
                                              TextStyle textStyle = TextStyle(
                                                fontSize: isBold ? 12 : 11,
                                                fontWeight: isBold
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              );
                                              return typePrice.name != ""
                                                  ? Text(
                                                      '$formattedCategory] от $formattedNameт - $formattedPrice₸',
                                                      style: textStyle,
                                                    )
                                                  : Row(
                                                      children: [
                                                        const Text(
                                                          'А] Цена: ',
                                                          style: TextStyle(
                                                              fontSize: 11),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            '$formattedPrice₸/шт',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: isBold
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .w500,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                            }).toList()
                                          : [const SizedBox()],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Ваша категория: '),
                                        Flexible(
                                          child: Text(
                                            goodsResponse!.categoryClient
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (quantity > 0) {
                                              setState(() {
                                                quantities[
                                                    goods.nomenklaturaKod ??
                                                        ""] = quantity - 1;
                                                controllers[
                                                        goods.nomenklaturaKod ??
                                                            ""]
                                                    ?.text = (quantity -
                                                        1)
                                                    .toString();
                                                _updateTotalAmount();
                                              });
                                              // Update cart if quantity is decreased
                                              addToCart(
                                                  context,
                                                  convertToSetOrderGoods(goods),
                                                  quantity - 1,
                                                  goods.parent ?? "");
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Количество товара не может быть меньше нуля'),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: quantity > 0
                                                  ? AppColors.primaryColor
                                                  : Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.remove,
                                                size: 28,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          width: 33,
                                          height: 33,
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true,
                                                    signed: true),
                                            controller: controllers[
                                                goods.nomenklaturaKod ?? ""],
                                            textAlign: TextAlign.center,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) {
                                              int? maxCount = int.tryParse(
                                                  goods.count ?? '0');
                                              int newQuantity =
                                                  int.tryParse(value) ?? 0;
                                              if (newQuantity >
                                                  (maxCount ?? 0)) {
                                                newQuantity = maxCount ?? 0;
                                                controllers[goods
                                                                .nomenklaturaKod ??
                                                            ""]
                                                        ?.text =
                                                    newQuantity.toString();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Достигнуто максимальное количество товара: $maxCount'),
                                                  ),
                                                );
                                              }
                                              setState(() {
                                                quantities[
                                                    goods.nomenklaturaKod ??
                                                        ""] = newQuantity;
                                                _updateTotalAmount();
                                              });
                                              // Update cart with new quantity
                                              addToCart(
                                                  context,
                                                  convertToSetOrderGoods(goods),
                                                  newQuantity,
                                                  goods.parent ?? "");
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        InkWell(
                                          onTap: () {
                                            int? maxCount = int.tryParse(
                                                goods.count ?? '0');
                                            if (quantity < (maxCount ?? 0)) {
                                              setState(() {
                                                quantities[
                                                    goods.nomenklaturaKod ??
                                                        ""] = quantity + 1;
                                                controllers[
                                                        goods.nomenklaturaKod ??
                                                            ""]
                                                    ?.text = (quantity +
                                                        1)
                                                    .toString();
                                                _updateTotalAmount();
                                              });
                                              // Add to cart if quantity is increased
                                              addToCart(
                                                  context,
                                                  convertToSetOrderGoods(goods),
                                                  quantity + 1,
                                                  goods.parent ?? "");
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Достигнуто максимальное количество товара: $maxCount'),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.add,
                                                size: 28,
                                                color: Colors.white,
                                              ),
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
            _addToCartAndNavigate();
          },
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${CustomNumberFormat.format(totalAmount)}₸, $totalUniqueItems товар',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
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
