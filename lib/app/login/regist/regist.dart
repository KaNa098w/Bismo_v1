import 'package:bismo/app/home/home_controller.dart';
import 'package:bismo/app/login/regist/regist_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Regist extends RouteManager {
  static const String name = '';
  static const String home = '${Regist.name}/regist';

  Regist() {
    addRoute(Regist.home, (context) => const RegistController());
  }
}
