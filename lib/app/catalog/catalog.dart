import 'package:bismo/app/catalog/catalog_controller.dart';
import 'package:bismo/app/catalog/goods/goods_controller.dart';
import 'package:bismo/app/catalog/goods/media/media_delete_controller.dart';
import 'package:bismo/app/catalog/goods/product/product_goods_controller.dart';
import 'package:bismo/app/catalog/search_catalog/search_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Catalog extends RouteManager {
  static const String name = '';
  static const String catalog = '${Catalog.name}/catalog';
  static const String goods = '${Catalog.name}/goods';
  static const String search = '${Catalog.name}/search';
  static const String media_delete_page = '${Catalog.name}/media_delete_page';
  static const String product_goods = '${Catalog.name}/product_goods';

  Catalog() {
    addRoute(Catalog.catalog, (context) => const CatalogController());
    addRoute(Catalog.goods, (context) => const GoodsController());
    addRoute(Catalog.search, (context) => const SearchCatalogController());
    addRoute(
        Catalog.media_delete_page, (context) => const MediaDeleteController());
    addRoute(
        Catalog.product_goods, (context) => const ProductGoodsController());
  }
}
