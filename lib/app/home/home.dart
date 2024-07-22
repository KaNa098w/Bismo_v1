import 'package:bismo/app/home/home_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Home extends RouteManager {
  static const String name = '';
  static const String home = '${Home.name}/home';

  Home() {
    addRoute(Home.home, (context) => const HomeController());
  }
}
