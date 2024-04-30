import 'package:bismo/app/catalog/catalog.dart';
import 'package:bismo/app/home/home.dart';
import 'package:bismo/core/classes/route_manager.dart';

class Routes extends RouteManager {
  Routes() {
    addAll(Catalog().routes);
    addAll(Home().routes);
  }
}
