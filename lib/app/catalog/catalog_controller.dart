import 'package:bismo/app/catalog/catalog_view.dart' as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:flutter/material.dart';

class CatalogController extends StatelessController {
  final String _title = 'Home Page';
  const CatalogController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    return Display(
      title: _title,
      mobile: mobile.CatalogView(title: _title),
    );
  }
}
