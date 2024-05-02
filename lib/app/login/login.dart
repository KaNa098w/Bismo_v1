import 'package:bismo/app/catalog/catalog_controller.dart';
import 'package:bismo/app/login/login_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Login extends RouteManager {
  static const String name = '';
  static const String home = '${Login.name}/login';

  Login() {
    addRoute(Login.home, (context) => const LoginController());
  }
}
