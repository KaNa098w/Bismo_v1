
import 'package:bismo/app/profile/profile_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Profile extends RouteManager {
  static const String name = '';
  static const String profile = '${Profile.name}/profile';

  Profile() {
    addRoute(Profile.profile, (context) => const ProfileController());
  }
}
