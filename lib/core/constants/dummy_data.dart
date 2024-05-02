import 'package:bismo/core/models/dummy_bundle_model.dart';
import 'package:bismo/core/models/dummy_product_model.dart';

class Dummy {
  /// List Of Dummy Products
  static List<ProductModel> products = [
    ProductModel(
      name: 'Пэрри-банан мороженое',
      weight: '800 гр',
      cover: 'https://i.imgur.com/6unJlSL.png',
      images: ['https://i.imgur.com/6unJlSL.png'],
      price: 1990,
      mainPrice: 2490,
    ),
    ProductModel(
      name: 'Венилла-клубника мороженое',
      weight: '500 гр',
      cover: 'https://i.imgur.com/oaCY49b.png',
      images: ['https://i.imgur.com/oaCY49b.png'],
      price: 1990,
      mainPrice: 2490,
    ),
    ProductModel(
      name: 'Мясо говядина',
      weight: '1 кг',
      cover: 'https://i.imgur.com/5wghZji.png',
      images: ['https://i.imgur.com/5wghZji.png'],
      price: 2150,
      mainPrice: 2900,
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
