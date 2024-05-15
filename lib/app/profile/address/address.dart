import 'package:bismo/app/profile/address/address_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Address extends RouteManager {
  static const String name = '';
  static const String home = '${Address.name}/address';

  Address() {
    addRoute(Address.home, (context) => const AddressController());
  }
}
