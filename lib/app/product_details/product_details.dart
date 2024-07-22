import 'package:bismo/app/product_details/all_view_products/all_products_controller.dart';
import 'package:bismo/app/product_details/product_details_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class ProductDetails extends RouteManager {
  static const String name = '';
  static const String product = '${ProductDetails.name}/product';
  static const String allView = '${ProductDetails.name}/all_view';

  ProductDetails() {
    addRoute(
        ProductDetails.product, (context) => const ProductDetailsController());
    addRoute(
        ProductDetails.allView, (context) => const AllProductsController());
  }
}
