import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/constants/dummy_data.dart';
import 'package:bismo/core/presentation/widgets/ad_space.dart';
import 'package:bismo/core/presentation/widgets/app_back_button.dart';
import 'package:bismo/core/presentation/widgets/bundle_tile_square.dart';
import 'package:bismo/core/presentation/widgets/our_new_item.dart';
import 'package:bismo/core/presentation/widgets/popular_packs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AllProductsView extends StatefulWidget {
  final String? title;
  const AllProductsView({Key? key, this.title}) : super(key: key);

  @override
  State<AllProductsView> createState() => _AllProductsViewState();
}

class _AllProductsViewState extends State<AllProductsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Популярые пакеты'),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
              child: GridView.builder(
                padding: const EdgeInsets.only(top: AppDefaults.padding),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.73,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return BundleTileSquare(
                    data: Dummy.bundles.first,
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(AppDefaults.padding * 2),
                decoration: const BoxDecoration(
                  color: Colors.white60,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, AppRoutes.createMyPack);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.shoppingBag),
                      const SizedBox(width: AppDefaults.padding),
                      const Text('Создать свой пакет'),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
