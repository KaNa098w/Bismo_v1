import 'package:bismo/app/cart/cart.dart';
import 'package:bismo/app/catalog/catalog.dart';
import 'package:bismo/app/home/home.dart';
import 'package:bismo/app/login/login.dart';
import 'package:bismo/app/product_details/all_view_products/all_products.dart';
import 'package:bismo/app/product_details/product_details.dart';
import 'package:bismo/app/profile/my_orders/orders.dart';
import 'package:bismo/app/profile/profile.dart';
import 'package:bismo/app/profile/settings/settings.dart';
import 'package:bismo/core/classes/route_manager.dart';
import 'package:bismo/core/models/user/user_info.dart';

class Routes extends RouteManager {
  Routes() {
    addAll(Catalog().routes);
    addAll(Home().routes);
    addAll(Profile().routes);
    addAll(Login().routes);
    addAll(ProductDetails().routes);
    addAll(AllProducts().routes);
    addAll(Cart().routes);
    addAll(Orders().routes);
    addAll(Settings().routes);
  }
}
