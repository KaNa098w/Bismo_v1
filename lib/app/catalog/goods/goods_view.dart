import 'dart:convert';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final String code;
  final int count;
  final int price;
  final String producer;
  final String photoUrl;

  Product({
    required this.name,
    required this.code,
    required this.count,
    required this.price,
    required this.producer,
    required this.photoUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['nomenklatura'],
      code: json['nomenklatura_kod'],
      count: json['count'],
      price: json['price'],
      producer: json['producer'],
      photoUrl: json['photo'],
    );
  }
}

class GoodsView extends StatefulWidget {
  final String? title;
  final String? responseFromPostman;

  const GoodsView({Key? key, this.title, this.responseFromPostman}) : super(key: key);

  @override
  _GoodsViewState createState() => _GoodsViewState();
}

class _GoodsViewState extends State<GoodsView> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _parseResponse(widget.responseFromPostman);
  }

  void _parseResponse(String? response) {
    if (response != null && response.isNotEmpty) {
      final decodedResponse = json.decode(response);
      if (decodedResponse['success'] == 'true') {
        final List<dynamic> goods = decodedResponse['goods'];
        products = goods.map((item) => Product.fromJson(item)).toList();
       
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Продукты и питания'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Цена: ${product.price}'),
            leading: Image.network(product.photoUrl),
            onTap: () {
             
            },
          );
        },
      ),
    );
  }
}
