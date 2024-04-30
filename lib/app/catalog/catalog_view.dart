import 'package:flutter/material.dart';

class CatalogView extends StatefulWidget {
  final String? title;
  const CatalogView({Key? key, this.title}) : super(key: key);

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text("Каталог"),
    );
  }
}
