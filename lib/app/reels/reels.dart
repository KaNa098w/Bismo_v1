import 'package:bismo/app/reels/reels_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Reels extends RouteManager {
  static const String name = '';
  static const String home = '${Reels.name}/reels';

  Reels() {
    addRoute(Reels.home, (context) => const ReelsController());
  }
}
