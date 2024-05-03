import 'package:bismo/core/presentation/widgets/coupon_code_field.dart';
import 'package:bismo/core/presentation/widgets/items_totals_price.dart';
import 'package:bismo/core/presentation/widgets/single_cart_item_tile.dart';
import 'package:flutter/material.dart';

class BasketView extends StatefulWidget {
  final String? title;
  const BasketView({Key? key, this.title}) : super(key: key);

  @override
  State<BasketView> createState() => _BasketViewState();
}

class _BasketViewState extends State<BasketView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: isHomePage
      //     ? null
      //     : AppBar(
      //         leading: const AppBackButton(),
      //         title: const Text('Cart Page'),
      //       ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingleCartItemTile(),
              SingleCartItemTile(),
              SingleCartItemTile(),
              CouponCodeField(),
              ItemTotalsAndPrice(),
              SizedBox(
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
