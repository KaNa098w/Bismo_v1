import 'package:bismo/app/profile/address/address_controller.dart';
import 'package:bismo/app/profile/my_orders/orders_controller.dart';
import 'package:bismo/app/profile/order_item/order_item_controller.dart';
import 'package:bismo/app/profile/profile_controller.dart';
import 'package:bismo/app/profile/settings/settings_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Profile extends RouteManager {
  static const String name = '';
  static const String profile = '${Profile.name}/profile';
  static const String address = '${Profile.name}/address';
  static const String orders = '${Profile.name}/orders';
  static const String settings = '${Profile.name}/settings';
  static const String orderItem = '${Profile.name}/order_item';

  Profile() {
    addRoute(Profile.profile, (context) => const ProfileController());
    addRoute(Profile.profile, (context) => const AddressController());
    addRoute(Profile.orders, (context) => const OrdersController());
    addRoute(Profile.settings, (context) => const SettingsController());
    addRoute(Profile.orderItem, (context) => const OrderItemController());
  }
}
