import 'package:bismo/app/profile/settings/settings_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Settings extends RouteManager {
  static const String name = '';
  static const String home = '${Settings.name}/settings';

  Settings() {
    addRoute(Settings.home, (context) => const SettingsController());
  }
}
