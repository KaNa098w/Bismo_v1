import 'dart:developer';
import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/app/product_details/product_details.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/exceptions.dart';
import 'package:bismo/core/models/cart/get_min_sum_response.dart';
import 'package:bismo/core/models/cart/promocode_bottom.dart';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:bismo/core/models/user/get_address_response.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/dialogs/loader_dialog.dart';
import 'package:bismo/core/presentation/widgets/custom_error_widget.dart';
import 'package:bismo/core/presentation/widgets/custom_number_format.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/cart_service.dart';
import 'package:bismo/core/services/min_sum_service.dart';
import 'package:bismo/core/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  final String? title;
  const CartView({Key? key, this.title}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<PersistentShoppingCartItem> cartItems = [];
  List<TextEditingController> _controllers = [];
  bool isLoaded = false;
  bool isDeliverySelected = false;
  GetAddressResponse? userAddress;
  Future<List<PersistentShoppingCartItem>>? _futureCartItems;
  String? selectedCategory;
  Map<String, int> minSumm = {};

  @override
  void initState() {
    super.initState();
    _futureCartItems = _loadCartItems();
    isDeliverySelected = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var userProvider = context.read<UserProvider>();
      var res =
          await _getUserAddress(userProvider.user?.phoneNumber ?? "", context);
      setState(() {
        userAddress = res;
      });
    });

    // Загрузка минимальных сумм
    _loadMinSumm();
  }

  Future<void> _loadMinSumm() async {
    print('Загрузка минимальных сумм...');
    MinSummService service = MinSummService();
    try {
      GetMinSumResponse? response = await service.getMinSum('sdsd');
      if (response != null) {
        Map<String, int> sums = {};
        response.body?.forEach((item) {
          sums[item.parent ?? ''] = item.summ ?? 0;
        });
        setState(() {
          minSumm = sums;
        });
      }
      print('Минимальные суммы успешно загружены: $minSumm');
    } catch (e) {
      print('Ошибка при загрузке минимальных сумм: $e');
    }
  }

  Future<List<PersistentShoppingCartItem>> _loadCartItems() async {
    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    cartItems =
        (cartData['cartItems'] ?? []) as List<PersistentShoppingCartItem>;
    _controllers.clear();
    _controllers = List.generate(cartItems.length, (index) {
      var newController = TextEditingController();
      newController.text = "${cartItems[index].quantity}";
      return newController;
    });

    setState(() {});

    isLoaded = true;

    return cartItems;
  }

  void removeFromCart(String productId) async {
    await PersistentShoppingCart().removeFromCart(productId);
    _futureCartItems = _loadCartItems();
  }

  void _showClearCartConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Очистить корзину?'),
          content: const Text('Вы уверены, что хотите очистить корзину?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалоговое окно
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  PersistentShoppingCart().clearCart();
                  _futureCartItems = _loadCartItems();
                });
                Navigator.of(context).pop(); // Закрыть диалоговое окно
              },
              child: const Text('Очистить'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String productName, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить товар?'),
          content: Text(
              'Вы уверены, что хотите удалить товар "$productName" из корзины?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалоговое окно
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалоговое окно
                removeFromCart(productId); // Удалить товар из корзины
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  Future<GetAddressResponse?> _getUserAddress(
      String phoneNumber, BuildContext ctx) async {
    try {
      var res = await UserService().getUserAddress(phoneNumber);
      return res;
    } on DioException catch (e) {
      log(e.toString());
      if (ctx.mounted) {
        hideLoader(ctx);
        showAlertDialog(
          context: ctx,
          barrierDismissible: true,
          title: "Ошибка",
          content: "Не удалось получить адрес пользователя!",
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              textStyle: const TextStyle(color: AppColors.primaryColor),
              child: const Text("OK"),
            ),
          ],
        );
      }
      return null;
    }
  }

  Future<void> _afterOrderCreate(
      BuildContext ctx, List<PersistentShoppingCartItem> items) async {
    setState(() {
      cartItems.removeWhere((item) =>
          items.contains(item)); // Удаляем только товары из выбранной категории
      isLoaded = false;
    });
    _loadCartItems();
  }

  String getCategoryName(String parent) {
    switch (parent) {
      case 'MA100001878':
        return '1000 мелочей';
      case '00000018150':
        return 'Китайская косметика';
      case 'MA100001883':
        return 'Оригинальная косметика';
      default:
        return 'Другие';
    }
  }

  int getMinAmount(String parent) {
    return minSumm[parent] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ToggleButtons(
                      isSelected: [isDeliverySelected, !isDeliverySelected],
                      onPressed: (int index) {
                        setState(() {
                          isDeliverySelected =
                              index == 0; // Обновление существующей переменной
                        });
                      },
                      selectedColor: Colors.white,
                      fillColor: Colors.purple,
                      borderRadius: BorderRadius.circular(12),
                      children: [
                        SizedBox(
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Доставка',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDeliverySelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Самовывоз',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isDeliverySelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: cartItems.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(
                    Icons.delete_sweep_outlined,
                    color: AppColors.primaryColor,
                    size: 33,
                  ),
                  onPressed: () {
                    _showClearCartConfirmationDialog(context);
                  },
                  tooltip: 'Очистить корзину',
                ),
              ]
            : null,
      ),
      body: FutureBuilder<List<PersistentShoppingCartItem>>(
        future: _futureCartItems,
        builder: (context,
            AsyncSnapshot<List<PersistentShoppingCartItem>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !isLoaded) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return const CustomErrorWidget();
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: 160,
                    color: Colors.purple[100],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Нет товаров',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
            );
          }

          // Группировка товаров по parent
          Map<String, List<PersistentShoppingCartItem>> groupedItems = {};
          for (var item in snapshot.data!) {
            String parent =
                item.productDetails?['parent']?.toString() ?? 'other';
            if (groupedItems[parent] == null) {
              groupedItems[parent] = [];
            }
            groupedItems[parent]!.add(item);
          }

          return ListView(
            children: groupedItems.entries.map((entry) {
              String parent = entry.key;
              String categoryName = getCategoryName(parent);
              List<PersistentShoppingCartItem> items = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (context, index) {
                      PersistentShoppingCartItem cartItem = items[index];

                      if (!_controllers.asMap().containsKey(index)) {
                        return const SizedBox();
                      }

                      double itemTotal = cartItem.unitPrice *
                          (cartItem.productDetails?['step'] ?? 1) *
                          cartItem.quantity;

                      return ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/product_goods',
                              arguments: GoodsArguments(
                                cartItem.productName ?? '',
                                cartItem.productId ?? '',
                                cartItem.productName ?? '',
                                0,
                                cartItem.productId ?? '',
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            child: CachedNetworkImage(
                              imageUrl: cartItem.productThumbnail ?? "",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/no_image.png',
                                fit: BoxFit.cover,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          cartItem.productName,
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Цена: ${CustomNumberFormat.format(cartItem.unitPrice)}₸/шт',
                              style: const TextStyle(fontSize: 13),
                            ),
                            Text(
                                'В упаковке: ${CustomNumberFormat.format(cartItem.productDetails!['step'])}шт x ${cartItem.quantity}',
                                style: const TextStyle(fontSize: 12)),
                            Text(
                              (cartItem.productDetails?['step'] != null)
                                  ? 'Сумма: ${CustomNumberFormat.format(cartItem.unitPrice * cartItem.productDetails!['step'] * cartItem.quantity)}₸'
                                  : '0₸',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (cartItem.quantity > 1)
                              GestureDetector(
                                onLongPress: () {
                                  _showDeleteConfirmationDialog(context,
                                      cartItem.productName, cartItem.productId);
                                },
                                child: IconButton(
                                  color: Colors.red,
                                  iconSize: 30,
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () {
                                    setState(() {
                                      cartItem.quantity--;
                                      _controllers[index].text =
                                          cartItem.quantity.toString();
                                    });
                                    PersistentShoppingCart()
                                        .removeFromCart(cartItem.productId);
                                    PersistentShoppingCart()
                                        .addToCart(cartItem);
                                  },
                                ),
                              )
                            else
                              IconButton(
                                iconSize: 30,
                                color: Colors.red,
                                icon: const Icon(Icons.delete_outline_rounded),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context,
                                      cartItem.productName, cartItem.productId);
                                },
                              ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 40,
                              height: 30,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _controllers[index],
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    cartItem.quantity = int.parse(value);
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              iconSize: 30,
                              color: AppColors.primaryColor,
                              icon: const Icon(Icons.add_box),
                              onPressed: () {
                                setState(() {
                                  cartItem.quantity++;
                                  _controllers[index].text =
                                      cartItem.quantity.toString();
                                });
                                PersistentShoppingCart()
                                    .removeFromCart(cartItem.productId);
                                PersistentShoppingCart().addToCart(cartItem);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Center(
                    child: SizedBox(
                      width: 350, // Установите необходимую ширину
                      height: 45, // Установите необходимую высоту
                      child: ElevatedButton(
                        onPressed: () {
                          double totalAmount = items.fold<double>(
                            0,
                            (total, item) =>
                                total +
                                (item.unitPrice *
                                    (item.productDetails?['step'] ?? 1) *
                                    item.quantity),
                          );

                          int minAmount = getMinAmount(parent);
                          print(
                              'Минимальная сумма для категории $parent: $minAmount');

                          if (totalAmount < minAmount) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Ошибка',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    content: Text(
                                        'Минимальный закуп в этой категории $minAmount₸'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            selectedCategory = parent;
                            _showBottomSheet(context, items, _afterOrderCreate);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purple, // Цвет кнопки
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Установите радиус для закругления углов
                          ),
                        ),
                        child: Text('Итого: ${CustomNumberFormat.format(
                          items.fold<double>(
                            0,
                            (total, item) =>
                                total +
                                (item.unitPrice *
                                    (item.productDetails?['step'] ?? 1) *
                                    item.quantity),
                          ),
                        )}₸, Оформить заказ'),
                      ),
                    ),
                  )
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context,
      List<PersistentShoppingCartItem> items,
      Function(BuildContext ctx, List<PersistentShoppingCartItem> items)
          afterOrderCreate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF5F5F5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return PromoCodeBottomSheet(
            cartItems: items,
            // setOrder: _setOrder,
            afterOrderCreate: afterOrderCreate,
            isDeliverySelected: isDeliverySelected);
      },
    );
  }
}
