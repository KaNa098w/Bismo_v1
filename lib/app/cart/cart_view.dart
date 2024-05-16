import 'dart:developer';

import 'package:bismo/core/colors.dart';
import 'package:bismo/core/exceptions.dart';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:bismo/core/models/user/get_address_response.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/dialogs/loader_dialog.dart';
import 'package:bismo/core/presentation/widgets/custom_error_widget.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/cart_service.dart';
import 'package:bismo/core/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _loadCartItems();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var res = await _getUserAddress("7777017100", context);
      setState(() {
        userAddress = res;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
  }

  Future<List<PersistentShoppingCartItem>> _loadCartItems() async {
    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    cartItems =
        (cartData['cartItems'] ?? []) as List<PersistentShoppingCartItem>;
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
    _loadCartItems();
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
                removeFromCart(productId); // Удалить товар из корзины
                Navigator.of(context).pop(); // Закрыть диалоговое окно
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

  Future<void> _setOrder(String phoneNumber, BuildContext ctx) async {
    showLoader(ctx);
    try {
      if (userAddress == null) {}

      int totalPrice = cartItems
          .fold<double>(
              0, (total, item) => total + (item.unitPrice * item.quantity))
          .toInt();

      var goods = cartItems.map((item) {
        return Goods(
          nomenklaturaKod: item.productDetails?['nomenklaturaKod'],
          producer: item.productDetails?['producer'] ?? "",
          price: item.unitPrice.toInt(),
          count: item.productDetails?['count'] ?? 0,
          step: item.productDetails?['step'] ?? 1,
          nomenklatura: item.productDetails?['nomenklatura'],
          comment: item.productDetails?['comment'] ?? "Нет комментарии",
          basketCount: item.quantity ?? 1,
        );
      }).toList();

      SetOrderRequest setOrderRequest = SetOrderRequest(
        provider: "7757499451",
        orderSum: totalPrice,
        providerName: "",
        deliveryAddress: userAddress?.allAdress?.last.adres,
        comment: "",
        counterparty: "7757499451",
        dolgota: userAddress?.allAdress?.last.dolgota,
        type: "0",
        providerPhoto:
            "https://bismo-products.object.pscloud.io/Bismocounterparties/%D0%96%D0%B0%D1%81%D0%9D%D1%83%D1%80.png",
        shirota: userAddress?.allAdress?.first.shirota,
        user: phoneNumber,
        goods: goods,
      );

      var res = await CartService().setOrder(setOrderRequest);

      if (res != null) {
        if (ctx.mounted) {
          hideLoader(ctx);
          showAlertDialog(
            context: ctx,
            barrierDismissible: true,
            title: "Уведомление",
            content: res.message ?? "",
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  // Закрыть диалоговое окно
                  Navigator.of(ctx).pop();

                  // Очистить корзину
                  PersistentShoppingCart().clearCart();
                  setState(() {
                    // Установить загрузку товаров в false
                    isLoaded = false;
                  });
                  _loadCartItems();
                },
                textStyle: const TextStyle(color: AppColors.primaryColor),
                child: const Text("OK"),
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
        title: Column(children: [
          // Text(
          //     'Выбрано: ${(cartItems.fold<int>(0, (total, item) => total + item.quantity))} товаров',
          //     style:
          //         const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isDeliverySelected = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDeliverySelected ? Colors.green : Colors.grey,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isDeliverySelected = true;
                    });
                  },
                  child: const Text(
                    'Доставка',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isDeliverySelected = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDeliverySelected ? Colors.grey : Colors.green,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isDeliverySelected = false;
                    });
                  },
                  child: const Text(
                    'Самовывоз',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
      body: FutureBuilder<List<PersistentShoppingCartItem>>(
          future: _loadCartItems(),
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
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove_shopping_cart_outlined,
                      size: 120,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Нет товаров',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                PersistentShoppingCartItem cartItem = snapshot.data![index];

                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage(cartItem.productThumbnail ?? ""),
                  ),
                  title: Text(cartItem.productName),
                  subtitle:
                      Text('${cartItem.unitPrice}₸ x ${cartItem.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (cartItem.quantity > 1)
                        IconButton(
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
                        width: 30,
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
                        color: Colors.green,
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
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Итого: ${(cartItems.fold<double>(0, (total, item) => total + (item.unitPrice * item.quantity))).toStringAsFixed(2)}₸',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                var userProvider = context.read<UserProvider>();

                _setOrder("7777017100", context);
              },
              child: const Text('Оформить заказ'),
            ),
          ],
        ),
      ),
    );
  }
}
