import 'package:bismo/app/cart/cart_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Cart extends RouteManager {
  static const String name = '';
  static const String home = '${Cart.name}/cart';

  Cart() {
    addRoute(Cart.home, (context) => const CartController());
  }
}
