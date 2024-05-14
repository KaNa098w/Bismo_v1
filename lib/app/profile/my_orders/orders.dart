import 'package:bismo/app/home/home_controller.dart';
import 'package:bismo/app/profile/my_orders/orders_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Orders extends RouteManager {
  static const String name = '';
  static const String home = '${Orders.name}/orders';

  Orders() {
    addRoute(Orders.home, (context) => const OrdersController());
  }
}
