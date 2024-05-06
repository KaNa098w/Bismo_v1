import 'dart:convert';
import 'dart:developer';
import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/models/user/SignInOtpResponse.dart';
import 'package:bismo/core/models/user/auth_response.dart';
import 'package:bismo/core/models/user/get_profile_response.dart';
import 'package:bismo/core/models/user/register_request.dart';
import 'package:bismo/core/models/user/register_response.dart';
import 'package:bismo/core/services/catalog_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bismo/core/presentation/widgets/category_tile.dart';

/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/

// Импортируйте ваш виджет CategoryTile здесь

class CatalogView extends StatefulWidget {
  final String? title;
  const CatalogView({Key? key, this.title}) : super(key: key);

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  late GlobalKey<NavigatorState> navigatorKey;

  List<Map<String, dynamic>> categories = [
    {
      "imageLink": 'https://cdn-icons-png.flaticon.com/512/1198/1198284.png',
      "label": 'Продукты питания',
    },
    {
      "imageLink": 'https://cdn-icons-png.flaticon.com/512/8708/8708840.png',
      "label": 'Мясо и рыба',
    },
    {
      "imageLink": 'https://cdn-icons-png.flaticon.com/512/1014/1014065.png',
      "label": 'Лекарства',
    },
    {
      "imageLink": 'https://cdn-icons-png.flaticon.com/512/856/856614.png',
      "label": 'Красота и здоровье',
    },
    {
      "imageLink": 'https://cdn-icons-png.flaticon.com/512/3721/3721614.png',
      "label": 'Очки',
    },
    {
      "imageLink": 'https://cdn-icons-png.flaticon.com/512/743/743031.png',
      "label": 'Пакеты',
    },
    {
      "imageLink": 'https://cdn-icons-png.flaticon.com/512/2938/2938229.png',
      "label": 'Товары для животных',
    },
    {
      "imageLink": 'https://cdn-icons-png.flaticon.com/512/5609/5609501.png',
      "label": 'Офисные товары',
    },
    {
      "imageLink": 'https://cdn-icons-png.flaticon.com/512/7438/7438654.png',
      "label": 'Спортивные товары',
    },
    {
      "imageLink": 'https://cdn-icons-png.flaticon.com/512/5117/5117071.png',
      "label": 'Садовые инструменты',
    },
    {
      "imageLink": 'https://i.imgur.com/m65fusg.png',
      "label": 'Другие',
    },
    // Добавьте сюда остальные категории при необходимости
  ];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future<CatalogResponse?> getCategories() async {
    try {
      var res = await CatalogService().getCategories('');

      print(res?.toJson());

      return res;
    } on DioException catch (e) {
      log(e.toString());

      return null;
    }

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(categories.length, (index) {
          return CategoryTile(
            imageLink: categories[index]["imageLink"],
            label: categories[index]["label"],
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/item');
                  break;
                case 1:
                  // Действие для второй категории (Мясо и рыба)
                  break;
                case 2:
                  // Действие для третьей категории (Лекарства)
                  break;
                case 3:
                  // Действие для четвертой категории (Красота и здоровье)
                  break;
                case 4:
                  // Действие для пятой категории (Очки)
                  break;
                case 5:
                  // Действие для шестой категории (Пакеты)
                  break;
                case 6:
                  // Действие для седьмой категории (Товары для животных)
                  break;
                case 7:
                  // Действие для восьмой категории (Офисные товары)
                  break;
                case 8:
                  // Действие для девятой категории (Спортивные товары)
                  break;
                case 9:
                  // Действие для десятой категории (Садовые инструменты)
                  break;
                case 10:
                  // Действие для одиннадцатой категории (Другие)
                  break;
                // Добавьте обработку других категорий здесь
              }
            },
          );
        }),
      ),
    );
  }
}
