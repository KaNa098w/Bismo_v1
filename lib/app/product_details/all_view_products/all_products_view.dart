import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/models/order/get_new_goods.dart';
import 'package:bismo/core/presentation/widgets/app_back_button.dart';
import 'package:bismo/core/presentation/widgets/product_tile_square.dart';
import 'package:bismo/core/services/new_goods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AllProductsView extends StatefulWidget {
  final String? title;
  const AllProductsView({Key? key, this.title}) : super(key: key);

  @override
  State<AllProductsView> createState() => _AllProductsViewState();
}

class _AllProductsViewState extends State<AllProductsView> {
  late Future<GetNewGoodsResponse?> _newGoodsFuture;
  bool _isSorted = false;
  List<Goods> _goods = [];

  @override
  void initState() {
    super.initState();
    _newGoodsFuture = NewGoodsService().getGoods('phone_number');
  }

  void _toggleSort() {
    setState(() {
      _isSorted = !_isSorted;
      if (_isSorted) {
        _goods.sort((a, b) => a.nomenklatura!.compareTo(b.nomenklatura!));
      } else {
        // Optionally, you can shuffle or reset the list if needed.
        _goods = List.from(_goods); // Just reassigning to trigger rebuild.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Популярные пакеты'),
        leading: const AppBackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _toggleSort,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<GetNewGoodsResponse?>(
          future: _newGoodsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Ошибка загрузки данных'));
            } else if (!snapshot.hasData || snapshot.data!.goods == null) {
              return const Center(child: Text('Нет данных'));
            }

            _goods = snapshot.data!.goods!;

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: AppDefaults.padding),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: _isSorted ? 400 : 300,
                        childAspectRatio: 0.62,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _goods.length,
                      itemBuilder: (context, index) {
                        return ProductTileSquare(
                          data: _goods[index],
                          newGoodsFuture: _newGoodsFuture,
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppDefaults.padding * 1),
                  decoration: const BoxDecoration(
                    color: Colors.white60,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
