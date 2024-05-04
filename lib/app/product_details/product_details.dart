import 'package:bismo/app/home/home_controller.dart';
import 'package:bismo/app/product_details/product_details_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class ProductDetails extends RouteManager {
  static const String name = '';
  static const String home = '${ProductDetails.name}/product';

  ProductDetails() {
    addRoute(ProductDetails.home, (context) => const ProductDetailsController());
  }
}
