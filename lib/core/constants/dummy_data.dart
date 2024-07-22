import 'package:bismo/core/models/dummy_bundle_model.dart';
import 'package:bismo/core/models/dummy_product_model.dart';

class Dummy {
  /// List Of Dummy Products
  static List<ProductModel> products = [
    ProductModel(
      name: 'Бьюти бокс набор',
      weight: 'скидка',
      cover: 'https://basket-02.wbbasket.ru/vol166/part16645/16645844/images/big/1.webp',
      images: ['https://basket-02.wbbasket.ru/vol166/part16645/16645844/images/big/1.webp'],
      price: 14990,
      mainPrice: 22490,
    ),
    ProductModel(
      name: 'Красная помада Belorus',
      weight: 'скидка',
      cover: 'https://lipstick.by/image/cache/catalog/products/boxes/2020/red/p2_2-800x800.jpg',
      images: ['https://lipstick.by/image/cache/catalog/products/boxes/2020/red/p2_2-800x800.jpg'],
      price: 12990,
      mainPrice: 22490,
    ),
    ProductModel(
      name: 'Мясо говядина',
      weight: 'скидка',
      cover: 'https://ir.ozone.ru/s3/multimedia-m/c1000/6021890002.jpg',
      images: ['https://ir.ozone.ru/s3/multimedia-m/c1000/6021890002.jpg'],
      price: 3150,
      mainPrice: 5900,
    ),
  ];

  /// List Of Dummy Bundles
  static List<BundleModel> bundles = [
    BundleModel(
      name: 'Пакет набор',
      cover: 'https://i.imgur.com/Y0IFT2g.png',
      itemNames: ['Лук, Помидор, Укроп,'],
      price: 3990,
      mainPrice: 5500,
    ),
    BundleModel(
      name: 'Хит продаж',
      cover: 'https://i.postimg.cc/qtM4zj1K/packs-2.png',
      itemNames: ['Масло, Огурцы, Соль'],
      price: 2790,
      mainPrice: 4200,
    ),
    BundleModel(
      name: 'Мини пакет',
      cover: 'https://i.postimg.cc/MnwW8WRd/pack-1.png',
      itemNames: ['Виноград, Имбирь, Укроп'],
      price: 3490,
      mainPrice: 5320,
    ),
    BundleModel(
      name: 'Средний',
      cover: 'https://i.postimg.cc/k2y7Jkv9/pack-4.png',
      itemNames: ['Черная бузина, Дягель, Ретка'],
      price: 2590,
      mainPrice: 4290,
    ),
  ];
}
