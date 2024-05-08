import 'package:bismo/app/catalog/catalog_controller.dart';
import 'package:bismo/app/catalog/goods/goods_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Catalog extends RouteManager {
  static const String name = '';
  static const String catalog = '${Catalog.name}/catalog';
  static const String goods = '${Catalog.name}/goods';

  Catalog() {
    addRoute(Catalog.catalog, (context) => const CatalogController());
    addRoute(Catalog.goods, (context) => const GoodsController());
  }
}
