import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/presentation/widgets/app_back_button.dart';
import 'package:bismo/core/presentation/widgets/bundle_details/bunde_widgets/bundle_meta_data.dart';
import 'package:bismo/core/presentation/widgets/bundle_details/bunde_widgets/bundle_pack_details.dart';
import 'package:bismo/core/presentation/widgets/bundle_details/bunde_widgets/buy_now_row_button.dart';
import 'package:bismo/core/presentation/widgets/bundle_details/bunde_widgets/price_and_quantity.dart';
import 'package:bismo/core/presentation/widgets/bundle_details/bunde_widgets/product_images_slider.dart';
import 'package:bismo/core/presentation/widgets/bundle_details/bunde_widgets/review_row_button.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatefulWidget {
  final String? title;
  const ProductDetailsView({Key? key, this.title}) : super(key: key);

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Детали пакета'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProductImagesSlider(
              images: [
                'https://lipstick.by/image/cache/catalog/products/boxes/2020/red/p2_2-800x800.jpg',
                'https://lipstick.by/image/cache/catalog/products/boxes/2020/red/p2_2-800x800.jpg',
                'https://lipstick.by/image/cache/catalog/products/boxes/2020/red/p2_2-800x800.jpg',
              ],
            ),
            /* <---- Product Data -----> */
            Padding(
              padding: const EdgeInsets.all(AppDefaults.padding),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Бьюити бокс',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  const PriceAndQuantityRow(
                    currentPrice: 20,
                    orginalPrice: 30,
                    quantity: 2,
                  ),
                  const SizedBox(height: AppDefaults.padding / 2),
                  const BundleMetaData(),
                  const PackDetails(),
                  const ReviewRowButton(totalStars: 5),
                  const Divider(thickness: 0.1),
                  BuyNowRow(
                    onBuyButtonTap: () {},
                    onCartButtonTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
