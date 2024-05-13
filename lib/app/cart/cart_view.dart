import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

class CartView extends StatefulWidget {
  final String? title;
  const CartView({Key? key, this.title}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<PersistentShoppingCartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    setState(() {
      cartItems =
          (cartData['cartItems'] ?? []) as List<PersistentShoppingCartItem>;
    });
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

// В вашем виджете, замените вызов removeFromCart(productId) на вызов _showDeleteConfirmationDialog(context, cartItem.productName, cartItem.productId)

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const Scaffold(
        body: Center(
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
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Корзина'),
        ),
        body: ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            PersistentShoppingCartItem cartItem = cartItems[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(cartItem.productThumbnail ?? ""),
              ),
              title: Text(cartItem.productName),
              subtitle: Text('${cartItem.unitPrice}₸ x ${cartItem.quantity}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cartItem.quantity > 1)
                    IconButton(
                      color: Colors.red,
                      iconSize: 30,
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          cartItem.quantity--;
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
                        _showDeleteConfirmationDialog(
                            context, cartItem.productName, cartItem.productId);
                      },
                    ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 40,
                    child: TextFormField(
                      initialValue: cartItem.quantity.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          cartItem.quantity = int.parse(value);
                        });
                      },
                    ),
                  ),
                  // IconButton(
                  //   iconSize: 30,
                  //   color: Colors.green,
                  //   icon: const Icon(Icons.add),
                  //   onPressed: () {
                  //     setState(() {
                  //       cartItem.quantity++;
                  //     });
                  //     PersistentShoppingCart()
                  //         .removeFromCart(cartItem.productId);
                  //     PersistentShoppingCart().addToCart(cartItem);
                  //   },
                  // ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Итого: ${(cartItems.fold<double>(0, (total, item) => total + (item.unitPrice * item.quantity))).toStringAsFixed(2)}₸',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Добавьте логику оформления заказа
                },
                child: const Text('Оформить заказ'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
