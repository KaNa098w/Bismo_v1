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
            imageLink: 'https://cdn-icons-png.flaticon.com/512/1198/1198284.png',
            label: 'Продукты питания',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://cdn-icons-png.flaticon.com/512/8708/8708840.png',
            label: 'Мясо и рыба',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://cdn-icons-png.flaticon.com/512/1014/1014065.png',
            label: 'Лекарство',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://cdn-icons-png.flaticon.com/512/876/876252.png',
            label: 'Забота о ребенке',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://cdn-icons-png.flaticon.com/512/5609/5609501.png',
            label: 'Офисные товары',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://cdn-icons-png.flaticon.com/512/856/856614.png',
            label: 'Красота и здоровье',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://cdn-icons-png.flaticon.com/512/7438/7438654.png',
            label: 'Спортивные товары',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://cdn-icons-png.flaticon.com/512/5117/5117071.png',
            label: 'Садовое инструменты',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://cdn-icons-png.flaticon.com/512/2938/2938229.png',
            label: 'Товары для животных',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://cdn-icons-png.flaticon.com/512/3721/3721614.png',
            label: 'Очки',
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.categoryDetails);
            },
          ),
          CategoryTile(
            imageLink: 'https://cdn-icons-png.flaticon.com/512/743/743031.png',
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
