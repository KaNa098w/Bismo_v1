import 'package:bismo/app/basket/basket_controller.dart';
import 'package:bismo/app/home/home_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Basket extends RouteManager {
  static const String name = '';
  static const String home = '${Basket.name}/basket';

  Basket() {
    addRoute(Basket.home, (context) => const BasketController());
  }
}
