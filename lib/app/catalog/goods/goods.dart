import 'package:bismo/app/catalog/goods/goods_controller.dart';
import 'package:bismo/app/home/home_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Goods extends RouteManager {
  static const String name = '';
  static const String home = '${Goods.name}/goods';

  Goods() {
    addRoute(Goods.home, (context) => const GoodsController());
  }
}
