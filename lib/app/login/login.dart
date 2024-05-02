import 'package:bismo/app/login/login_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Login extends RouteManager {
  static const String name = '';
  static const String login = '${Login.name}/login';

  Login() {
    addRoute(Login.login, (context) => const LoginController());
  }
}
