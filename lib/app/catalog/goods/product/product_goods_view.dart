import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/app/catalog/goods/media/photo_upload_helped.dart';
import 'package:bismo/app/catalog/goods/media/video_upload_helper.dart';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'dart:developer';

import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

class ProductGoodsView extends StatefulWidget {
  final Goods goods;
  const ProductGoodsView({Key? key, required this.goods}) : super(key: key);

  @override
  State<ProductGoodsView> createState() => _ProductGoodsViewState();
}

class _ProductGoodsViewState extends State<ProductGoodsView> {
  int quantity = 0;
  List<String> productImages = [];
  Goods? goods;

  @override
  void initState() {
    super.initState();
    goods = widget.goods;
    _fetchGoods(goods!.catId ?? '');
  }

  Future<void> _fetchGoods(String catId) async {
    try {
      final String url =
          'http://188.95.95.122:2223/server/hs/product/getfullprice?login_provider=7757499451&cat_id=$catId';
      print('*** Request ***');
      print('uri: $url');
      print('method: GET');

      var dio = Dio();
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        GoodsResponse goodsResponse = GoodsResponse.fromJson(response.data);
        setState(() {
          goods = goodsResponse.goods
              ?.firstWhere((element) => element.catId == catId);
          loadProductImages(catId);
        });
      } else {
        throw Exception(
            'Failed to load goods. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log("Error fetching goods: $e");
    }
  }

  Future<void> loadProductImages(String catId) async {
    final url = 'http://86.107.45.59/api/images?phone=7783734209&code=$catId';
    var headers = {'Accept': 'application/json'};
    var dio = Dio();
    try {
      var response = await dio.request(
        url,
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        if (data is List) {
          setState(() {
            productImages = data
                .where((image) =>
                    image.endsWith('.png') ||
                    image.endsWith('.jpg') ||
                    image.endsWith('.jpeg'))
                .map((image) => 'https://dulat.object.pscloud.io/$image')
                .toList();
          });
        } else {
          throw Exception("Unexpected data format");
        }
      } else {
        log(response.statusMessage ?? 'Unknown error');
      }
    } catch (e) {
      log("Error fetching product images: $e");
    }
  }

  void addToCart(Goods goods, int quantity) async {
    await PersistentShoppingCart().addToCart(PersistentShoppingCartItem(
      productId: goods.nomenklaturaKod ?? "",
      productName: goods.nomenklatura ?? "",
      unitPrice: goods.price ?? 0.0,
      quantity: quantity,
      productThumbnail: goods.photo,
      productDetails: {
        "nomenklatura": goods.nomenklatura,
        "nomenklaturaKod": goods.nomenklaturaKod,
        "producer": goods.producer,
        "step": goods.step,
        "count": goods.count,
      },
    ));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Товар добавлен в корзину'),
      backgroundColor: Colors.green,
      duration: Duration(milliseconds: 500),
    ));
  }

  void openAppSettings() {
    openAppSettings();
  }

  Future<void> requestStoragePermission(Function onPermissionGranted) async {
    var status = await Permission.storage.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      onPermissionGranted();
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Пожалуйста, предоставьте доступ к хранилищу в настройках'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Открыть настройки',
            onPressed: () {
              openAppSettings();
            },
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Доступ к хранилищу не предоставлен'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goods.nomenklatura ?? 'Детали товара'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: goods != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  if (productImages.isNotEmpty)
                    Container(
                      height: 200,
                      child: PageView.builder(
                        itemCount: productImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: productImages[index],
                                cacheManager: null, // Disable caching
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.network(
                                  'https://images.satu.kz/197787004_w200_h200_pomада-для-губ.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    goods!.nomenklatura ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            if (quantity > 0) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: quantity > 0 ? Colors.blue : Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.remove,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text("$quantity"),
                      const SizedBox(width: 20),
                      Center(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '${goods!.price?.toInt()}₸/кг',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        goods!.kontragent ?? "",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(width: 50),
                      Text(
                        "Сумма: ${(quantity * (goods!.price ?? 0)).toStringAsFixed(2)}₸",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      Icon(Icons.star,
                          color: Color.fromARGB(255, 94, 94, 93), size: 18),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Комментария, пожелания',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // requestStoragePermission(() {
                              uploadPhoto(
                                context,
                                '7783734209',
                                goods!.nomenklaturaKod ?? "",
                                goods!.catId ?? "",
                                () {
                                  setState(
                                      () {}); // Обновление состояния внутри диалога
                                  _fetchGoods(goods!.catId ??
                                      ""); // Обновление данных на странице
                                },
                                (newPhotoUrl) {
                                  setState(() {
                                    goods!.photo =
                                        newPhotoUrl; // Обновление URL изображения
                                  });
                                },
                              );
                              // });
                            },
                            icon: const Icon(Icons.add_photo_alternate_outlined,
                                color: Colors.blue),
                            label: const Text(
                              'Загрузить фото',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/media_delete_page',
                                arguments: GoodsArguments(
                                    'Медиафайлы', goods!.nomenklaturaKod ?? ''),
                              );
                            },
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: Colors.red),
                            label: const Text(
                              '',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      TextButton.icon(
                        onPressed: () {
                          uploadVideo(context, goods!.nomenklaturaKod ?? '');
                        },
                        icon: const Icon(Icons.video_chat_outlined,
                            color: Colors.blue),
                        label: const Text(
                          'Загрузить видео',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
