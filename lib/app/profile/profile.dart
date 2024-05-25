import 'package:bismo/app/profile/address/address_controller.dart';
import 'package:bismo/app/profile/address/location/location_controller.dart';
import 'package:bismo/app/profile/my_orders/orders_controller.dart';
import 'package:bismo/app/profile/my_profile/my_profile_controller.dart';
import 'package:bismo/app/profile/notification/notification_controller.dart';
import 'package:bismo/app/profile/order_item/order_item_controller.dart';
import 'package:bismo/app/profile/profile_controller.dart';
import 'package:bismo/app/profile/settings/settings_controller.dart';
import 'package:bismo/app/profile/support/support_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Profile extends RouteManager {
  static const String name = '';
  static const String profile = '${Profile.name}/profile';
  static const String address = '${Profile.name}/address';
  static const String orders = '${Profile.name}/orders';
  static const String settings = '${Profile.name}/settings';
  static const String orderItem = '${Profile.name}/order_item';
  static const String location = '${Profile.name}/location';
  static const String notification = '${Profile.name}/notification';
  static const String my_profile = '${Profile.name}/my_profile';
  static const String support = '${Profile.name}/support';

  Profile() {
    addRoute(Profile.profile, (context) => const ProfileController());
    addRoute(Profile.address, (context) => const AddressController());
    addRoute(Profile.orders, (context) => const OrdersController());
    addRoute(Profile.settings, (context) => const SettingsController());
    addRoute(Profile.orderItem, (context) => const OrderItemController());
    addRoute(Profile.location, (context) => const LocationController());
    addRoute(Profile.notification, (context) => const NotificationController());
    addRoute(Profile.my_profile, (context) => const MyProfileController());
    addRoute(Profile.support, (context) => const SupportController());
  }
}
