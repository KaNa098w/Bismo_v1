import 'dart:developer';
import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/app/product_details/product_details.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/exceptions.dart';
import 'package:bismo/core/models/cart/promocode_bottom.dart';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:bismo/core/models/user/get_address_response.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/dialogs/loader_dialog.dart';
import 'package:bismo/core/presentation/widgets/custom_error_widget.dart';
import 'package:bismo/core/presentation/widgets/custom_number_format.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/cart_service.dart';
import 'package:bismo/core/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  @override
  void initState() {
    super.initState();
    _futureCartItems = _loadCartItems();
    isDeliverySelected = true; // Добавьте эту строку

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var userProvider = context.read<UserProvider>();
      var res =
          await _getUserAddress(userProvider.user?.phoneNumber ?? "", context);
      setState(() {
        userAddress = res;
      });
    });
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
    // setState(() {});
    // _loadCartItems();
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

  Future<void> _setOrder(BuildContext ctx) async {
    var userProvider = context.read<UserProvider>();
    showLoader(ctx);
    try {
      if (userAddress == null) {}

      int totalPrice = cartItems
          .fold<double>(
              0, (total, item) => total + (item.unitPrice * item.quantity))
          .toInt();

      var goods = cartItems.map((item) {
        return SetOrderGoods(
          nomenklaturaKod: item.productDetails?['nomenklaturaKod'],
          producer: item.productDetails?['producer'] ?? "",
          price: item.unitPrice,
          count: item.productDetails?['count'] ?? 0,
          step: item.productDetails?['step'], // Извлекаем значение поля step
          nomenklatura: item.productDetails?['nomenklatura'],
          comment: item.productDetails?['comment'] ?? "Нет комментарии",
          basketCount: item.quantity ?? 1,
        );
      }).toList();

      SetOrderRequest setOrderRequest = SetOrderRequest(
        provider: "7757499451",
        orderSum: totalPrice,
        providerName: "",
        deliveryAddress: userProvider.userAddress?.deliveryAddress,
        comment: "",
        counterparty: "7757499451",
        dolgota: userProvider.userAddress?.dolgota,
        type: isDeliverySelected ? "0" : "1",
        providerPhoto:
            "https://bismo-products.object.pscloud.io/Bismocounterparties/%D0%96%D0%B0%D1%81%D0%9D%D1%83%D1%80.png",
        shirota: userProvider.userAddress?.shirota,
        user: userProvider.user?.phoneNumber,
        goods: goods,
      );

      var res = await CartService().setOrder(setOrderRequest);

      if (res != null) {
        if (ctx.mounted) {
          hideLoader(ctx);
          showAlertDialog(
            context: ctx,
            barrierDismissible: false,
            title: "Уведомление",
            content: res.message ?? "",
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  PersistentShoppingCart().clearCart();
                  setState(() {
                    isLoaded = false;
                  });
                  _loadCartItems();
                  Navigator.pop(ctx);
                  if (isDeliverySelected) {
                    Navigator.pop(ctx);
                  }
                  Navigator.pushNamed(ctx, "/orders");
                },
                textStyle: const TextStyle(color: AppColors.primaryColor),
                child: const Text("Перейти в мои заказы"),
              ),
            ],
          );
        }
      }
    } on DioException catch (e) {
      log(e.toString());
      final errorMessage = DioExceptions.fromDioError(e).toString();

      if (ctx.mounted) {
        hideLoader(ctx);
        showAlertDialog(
          context: ctx,
          barrierDismissible: true,
          title: "Ошибка",
          content: errorMessage,
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              textStyle: const TextStyle(color: AppColors.primaryColor),
              child: const Text("OK"),
            ),
          ],
        );
      }
    }
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
                  icon: Icon(
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

          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (context, index) {
              PersistentShoppingCartItem cartItem = snapshot.data![index];

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
                title: Text(cartItem.productName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Цена: ${CustomNumberFormat.format(cartItem.unitPrice)}₸/шт',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                        'В упаковке: ${CustomNumberFormat.format(cartItem.productDetails!['step'])}шт x ${cartItem.quantity}',
                        style: TextStyle(fontSize: 13)),
                    Text(
                      (cartItem.unitPrice != null &&
                              cartItem.productDetails?['step'] != null)
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
                            PersistentShoppingCart().addToCart(cartItem);
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
          );
        },
      ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? BottomAppBar(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  if (isDeliverySelected) {
                    _showBottomSheet(context);
                  } else {
                    _setOrder(context);
                  }
                },
                child: Container(
                  height: 50,
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
                            'Итого: ${CustomNumberFormat.format(
                              cartItems.fold<double>(
                                0,
                                (total, item) =>
                                    total +
                                    (item.unitPrice *
                                        (item.productDetails?['step'] ?? 1) *
                                        item.quantity),
                              ),
                            )}₸',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );

    // child: Text(
    //   'Итого: ${CustomNumberFormat.format(
    //     cartItems.fold<double>(
    //       0,
    //       (total, item) =>
    //           total +
    //           (item.unitPrice *
    //               (item.productDetails?['step'] ?? 1) *
    //               item.quantity),
    //     ),
    //   )}₸',
    //                 // ),
    //               ),
    //               ElevatedButton(
    //                 onPressed: () {
    //                   if (isDeliverySelected) {
    //                     _showBottomSheet(context);
    //                   } else {
    //                     _setOrder(context);
    //                   }
    //                 },
    //                 style: ElevatedButton.styleFrom(
    //                   foregroundColor: Colors.white,
    //                   backgroundColor: Colors.red,
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 20, vertical: 12),
    //                   textStyle: const TextStyle(fontSize: 16),
    //                 ),
    //                 child: const Text(
    //                   'Оформить заказ',
    //                   style: TextStyle(color: Colors.white),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         )
    //       : null,
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF5F5F5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return PromoCodeBottomSheet(cartItems: cartItems);
      },
    );
  }
}
