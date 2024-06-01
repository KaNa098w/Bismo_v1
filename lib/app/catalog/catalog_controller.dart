import 'package:bismo/app/catalog/catalog_arguments.dart';
import 'package:bismo/app/catalog/catalog_view.dart' as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:flutter/material.dart';

class CatalogController extends StatelessController {
  final String _title = 'Каталог';
  const CatalogController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as CatalogArguments
        : CatalogArguments("Каталог", "");
    return Display(
      title: _title,
      mobile: mobile.CatalogView(title: args.title, catId: args.catId),
    );
  }
}
