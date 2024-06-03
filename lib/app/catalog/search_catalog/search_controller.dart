import 'package:bismo/app/catalog/search_catalog/search_view.dart' as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:bismo/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchCatalogController extends StatelessController {
  final String _title = 'Поиск';
  const SearchCatalogController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    var tm = context.read<ThemeProvider>();
    tm.setNavIndex(0);

    return Display(
      title: _title,
      mobile: mobile.SearchCatalogView(title: _title),
    );
  }
}
