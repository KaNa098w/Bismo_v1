import 'package:bismo/core/presentation/widgets/category_tile.dart';
import 'package:flutter/material.dart';

class CatologView extends StatefulWidget {
  final String? title;
  const CatologView({Key? key, this.title}) : super(key: key);

  @override
  State<CatologView> createState() => _CatologViewState();
}

class _CatologViewState extends State<CatologView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GridView.count(
        crossAxisCount: 3,
        children: [
          CategoryTile(
            imageLink: 'https://i.imgur.com/yOFxoIP.png',
            iconSize: 36,
            label: 'Продукты питания',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://i.imgur.com/yOFxoIP.png',
            label: 'Мясо и рыба',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://i.imgur.com/GPsRaFC.png',
            label: 'Лекарство',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://i.imgur.com/mGRqfnc.png',
            label: 'Забота о ребенке',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://i.imgur.com/fwyz4oC.png',
            label: 'Офисные товары',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://i.imgur.com/DNr8a6R.png',
            label: 'Красота и здоровье',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://i.imgur.com/O2ZX5nR.png',
            label: 'Спортивные товары',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://i.imgur.com/wJBopjL.png',
            label: 'Садовое инструменты',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://i.imgur.com/P4yJA9t.png',
            label: 'Товары для животных',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://i.imgur.com/sxGf76e.png',
            label: 'Очки',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://i.imgur.com/BPvKeXl.png',
            label: 'Пакеты',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://i.imgur.com/m65fusg.png',
            label: 'Другие',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
        ],
      ),
    );
  }
}
