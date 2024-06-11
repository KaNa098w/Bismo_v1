import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/models/order/get_new_goods.dart';
import 'package:bismo/core/presentation/widgets/product_tile_square.dart';
import 'package:bismo/core/presentation/widgets/title_and_action_button.dart';
import 'package:bismo/core/services/new_goods.dart';
import 'package:flutter/material.dart';

class OurNewItem extends StatefulWidget {
  const OurNewItem({Key? key}) : super(key: key);

  @override
  _OurNewItemState createState() => _OurNewItemState();
}

class _OurNewItemState extends State<OurNewItem> {
  late Future<GetNewGoodsResponse?> _newGoodsFuture;

  @override
  void initState() {
    super.initState();
    _newGoodsFuture = NewGoodsService().getUserAddress('phone_number');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleAndActionButton(
          title: 'Новинки',
          onTap: () {
            Navigator.pushNamed(context, '/product');
          },
        ),
        SizedBox(
          height: 300,
          child: FutureBuilder<GetNewGoodsResponse?>(
            future: _newGoodsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Ошибка загрузки данных'));
              } else if (!snapshot.hasData || snapshot.data!.goods == null) {
                return Center(child: Text('Нет данных'));
              }

              final goods = snapshot.data!.goods!;

              return SingleChildScrollView(
                padding: const EdgeInsets.only(left: AppDefaults.padding),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: goods
                      .map((item) => ProductTileSquare(
                            data: item,
                            newGoodsFuture: _newGoodsFuture,
                          ))
                      .toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
