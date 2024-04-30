import 'package:bismo/app/catalog/catalog_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Catalog extends RouteManager {
  static const String name = '';
  static const String home = '${Catalog.name}/catalog';

  Catalog() {
    addRoute(Catalog.home, (context) => const CatalogController());
  }
}
