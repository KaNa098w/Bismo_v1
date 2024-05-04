import 'package:bismo/app/home/home_controller.dart';
import 'package:bismo/app/product_details/all_view_products/all_products_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class AllProducts extends RouteManager {
  static const String name = '';
  static const String home = '${AllProducts.name}/all_view';

  AllProducts() {
    addRoute(AllProducts.home, (context) => const AllProductsController());
  }
}
