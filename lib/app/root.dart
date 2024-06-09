import 'package:bismo/app/cart/cart_controller.dart';
import 'package:bismo/app/catalog/catalog_controller.dart';
import 'package:bismo/app/home/home_controller.dart';
import 'package:bismo/app/profile/profile_controller.dart';
import 'package:bismo/app/reels/reels_controller.dart';
import 'package:bismo/core/models/bottom_nav_bar.dart';
import 'package:bismo/core/models/button_data.dart';
import 'package:bismo/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'catalog/goods/media/video_upload_helper.dart'; // Импортируем наш новый файл

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool dayAndNight = false;
  double sized = 5;
  int index = 0;
  int len = 0;

  List<ButtonData>? buttonDatas = [
    ButtonData(
        page: const HomeController(),
        icon: Icons.shopping_bag_outlined,
        labelRu: 'Магазин',
        labelKk: 'Магазин',
        labelEn: 'Магазин',
        link: '/home',
        isProtected: false),
    ButtonData(
        page: const CatalogController(),
        icon: Icons.manage_search,
        labelRu: 'Каталог',
        labelKk: 'Каталог',
        labelEn: 'Каталог',
        link: '/catalog',
        isProtected: false),
    ButtonData(
        page: const ReelsController(),
        icon: Icons.play_circle_outlined,
        labelRu: 'Reels',
        labelKk: 'Reels',
        labelEn: 'Reels',
        link: '/reels',
        isProtected: false),
    ButtonData(
        page: const CartController(),
        icon: Icons.shopping_cart_outlined,
        labelRu: 'Корзина',
        labelKk: 'Корзина',
        labelEn: 'Корзина',
        link: '/basket',
        isProtected: false),
    ButtonData(
        page: const ProfileController(),
        icon: Icons.perm_identity,
        labelRu: 'Профиль',
        labelKk: 'Профиль',
        labelEn: 'Профиль',
        link: '/profile',
        isProtected: false),
  ];

  List<ButtonData> get buttonData => buttonDatas!;

  void _selectPage(int index, BuildContext context) async {
    var tm = context.read<ThemeProvider>();

    tm.setNavIndex(index);
    index = index;

    print(index);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    index = Provider.of<ThemeProvider>(context, listen: true).index;
  }

  @override
  Widget build(BuildContext context) {
    len = buttonDatas!.length;
    var tm = context.read<ThemeProvider>();
    index = tm.index;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          buttonData[index].labelRu,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF19191B),
          ),
        ),
        actions: index == 2 ? [ 
          
        ] : null,
      ),
      body: buttonData[index].page,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 7, 77, 182),
        unselectedItemColor: const Color(0xFF999999),
        currentIndex: index,
        onTap: (val) => _selectPage(val, context),
        items: buttonData
            .map(
              (e) =>
                  bottomNavigationBarItem(icon: Icon(e.icon), label: e.labelRu),
            )
            .toList(),
      ),
    );
  }
}
