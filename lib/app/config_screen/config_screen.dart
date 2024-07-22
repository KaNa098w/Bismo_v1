import 'package:bismo/app/config_screen/config_screen_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class ConfigScreen extends RouteManager {
  static const String name = '';
  static const String template = '${ConfigScreen.name}/config';

  ConfigScreen() {
    addRoute(
        ConfigScreen.template, (context) => const ConfigScreenController());
  }
}
