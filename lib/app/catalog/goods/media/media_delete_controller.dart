import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/app/catalog/goods/media/media_delete_view.dart' as mobile;
import 'package:bismo/core/classes/controller_manager.dart';
import 'package:bismo/core/classes/display_manager.dart';
import 'package:flutter/material.dart';

class MediaDeleteController extends StatelessController {
  final String _title = 'Продукты и питания';
  const MediaDeleteController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GoodsArguments;
    return Display(
      title: _title,
      mobile: mobile.MediaDeleteView(
        title: args.title,
        phone: '7783734209',
        code: args.nomenklaturaKod, // Используем переданный код
      ),
    );
  }
}
