import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/app/catalog/goods/media/photo_upload_helped.dart';
import 'package:bismo/app/catalog/goods/media/video_upload_helper.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:bismo/core/models/catalog/fullscreenimage.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/widgets/video_player_product.dart';
import 'package:bismo/core/services/goods_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'dart:developer';

import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:video_player/video_player.dart';

class ProductGoodsView extends StatefulWidget {
  final Goods goods;
  final GoodsArguments arguments;
  const ProductGoodsView(
      {Key? key, required this.goods, required this.arguments})
      : super(key: key);

  @override
  State<ProductGoodsView> createState() => _ProductGoodsViewState();
}

class _ProductGoodsViewState extends State<ProductGoodsView> {
  int quantity = 1;
  int starClickCount = 0;
  List<String> productImages = [];
  List<String> productVideos = [];
  Goods? goods;
  bool showSecretButtons = false;

  @override
  void initState() {
    super.initState();
    _fetchGoods(widget.arguments.nomenklaturaKod);
    loadProductImages(widget.arguments.nomenklaturaKod);
    _initializeQuantity();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeQuantity();
  }

  Future<void> _initializeQuantity() async {
    Map<String, dynamic> cartData = PersistentShoppingCart().getCartData();
    List<PersistentShoppingCartItem> cartItems =
        (cartData['cartItems'] ?? []) as List<PersistentShoppingCartItem>;
    for (var item in cartItems) {
      if (item.productId == widget.arguments.nomenklaturaKod) {
        setState(() {
          quantity = item.quantity;
        });
        break;
      }
    }
  }

  Future<void> _fetchGoods(String nomenklaturaKod) async {
    try {
      final response = await GoodsService().getGood(nomenklaturaKod);

      setState(() {
        goods = response?.goods?.firstWhere(
            (element) => element.nomenklaturaKod == nomenklaturaKod);
      });
    } catch (e) {
      log("Error fetching goods: $e");
    }
  }

  Future<void> loadProductImages(String nomenklaturaKod) async {
    final url =
        'http://86.107.45.59/api/images?phone=7783734209&code=$nomenklaturaKod';
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
                .where(
                    (image) => !image.endsWith('.mp4')) // Exclude video files
                .map((image) => 'https://dulat.object.pscloud.io/$image')
                .toList();
            productVideos = data
                .where((image) =>
                    image.endsWith('.mp4')) // Include only video files
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

  void addToCart(BuildContext context, SetOrderGoods goods, int quantity,
      String? parent) async {
    bool itemExists = await PersistentShoppingCart()
        .removeFromCart(goods.nomenklaturaKod ?? "");

    if (itemExists) {
      // Если товар существует, удалите его
      await PersistentShoppingCart()
          .removeFromCart(goods.nomenklaturaKod ?? "");
    }

    await PersistentShoppingCart().addToCart(PersistentShoppingCartItem(
      productId: goods.nomenklaturaKod ?? "",
      productName: goods.nomenklatura ?? "",
      unitPrice: goods.price ?? 0.0,
      quantity: quantity,
      productThumbnail: goods.photo,
      productDetails: {
        "nomenklatura": goods.nomenklatura,
        "nomenklaturaKod": goods.nomenklaturaKod,
        "producer": goods.kontragent,
        "step": goods.step,
        "count": goods.count,
        "parent": parent,
      },
    ));
  }

  SetOrderGoods convertToSetOrderGoods(Goods goods) {
    return SetOrderGoods(
      nomenklatura: goods.nomenklatura,
      nomenklaturaKod: goods.nomenklaturaKod,
      count: int.tryParse(goods.count ?? '0'),
      price: goods.price?.toDouble(),
      optPrice: goods.optPrice?.toDouble(),
      producer: goods.kontragent,
      kontragent: goods.kontragent,
      step: goods.step,
      newProduct: goods.newProduct,
      photo: goods.photo,
      catId: goods.catId,
      oldPrice: goods.oldPrice?.toDouble(),
      newsPhoto: goods.newsPhoto,
      comment: '',
      basketCount: 0,
    );
  }

  void openAppSettings() {
    openAppSettings();
  }

  void _openFullScreenImage(List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullScreenImage(images: images, initialIndex: initialIndex),
      ),
    );
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
        title: Center(
          child: Text(
            goods?.nomenklatura ?? "",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: goods != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (productImages.isNotEmpty || productVideos.isNotEmpty)
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        itemCount: productImages.length + productVideos.length,
                        itemBuilder: (context, index) {
                          if (index < productImages.length) {
                            // Show image
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  _openFullScreenImage(
                                      productImages + productVideos, index);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: productImages[index],
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) {
                                      print(
                                          "Failed to load image $url, error: $error");
                                      return Image.asset(
                                          'assets/images/no_image.png');
                                    },
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // Show video
                            String videoUrl =
                                productVideos[index - productImages.length];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: VideoPlayerWidgetProduct(
                                    videoUrl: videoUrl),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  if (productImages.isEmpty)
                    Center(
                      child: Image.asset(
                        'assets/images/no_image.png',
                        width: 250,
                        height: 250,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      goods!.nomenklatura ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Цена: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${goods?.price}₸/шт',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Количество: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (quantity > 0) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: quantity > 0
                                      ? AppColors.primaryColor
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.remove,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "$quantity",
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Поставщик:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          goods?.kontragent ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Общая сумма:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${((goods?.step)! * quantity * (goods?.price ?? 0)).toStringAsFixed(2)}₸",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'В упаковке:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${(goods?.step)}шт в коробке",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: List.generate(5, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              starClickCount++;
                              if (starClickCount >= 10) {
                                showSecretButtons =
                                    true; // Показать кнопки после 10 кликов
                              }
                            });
                          },
                          child: Icon(
                            index < 4 ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          ),
                        );
                      }),
                    ),
                  ),
                  if (showSecretButtons)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              uploadPhoto(
                                  context,
                                  '7783734209',
                                  goods?.nomenklaturaKod ?? "",
                                  goods?.catId ?? "", () {
                                _fetchGoods(widget.arguments.nomenklaturaKod);
                                loadProductImages(
                                    widget.arguments.nomenklaturaKod);
                              }, (newPhotoUrl) {
                                // Обновление URL фото
                                // Пример: goods!.photo = newPhotoUrl;
                              });
                            },
                            icon: const Icon(Icons.add_photo_alternate_outlined,
                                color: Colors.blue),
                            label: const Text(
                              'Загрузить фото',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton.icon(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/media_delete_page',
                                arguments: GoodsArguments(
                                  'Медиафайлы',
                                  '',
                                  '',
                                  0,
                                  goods?.nomenklaturaKod ?? "",
                                ),
                              );

                              _fetchGoods(goods?.nomenklaturaKod ?? "");
                              loadProductImages(goods?.nomenklaturaKod ?? "");
                            },
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: Colors.red),
                            label: const Text(
                              'Удалить',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (showSecretButtons)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextButton.icon(
                        onPressed: () {
                          uploadVideo(context, goods?.nomenklaturaKod ?? "");
                        },
                        icon: const Icon(Icons.video_chat_outlined,
                            color: Colors.blue),
                        label: const Text(
                          'Загрузить видео',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Комментария, пожелания',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: Row(
                  //     children: [
                  //       TextButton.icon(
                  //         onPressed: () {
                  //           uploadPhoto(
                  //             context,
                  //             '7783734209',
                  //             goods?.nomenklaturaKod ?? "",
                  //             goods?.catId ?? "",
                  //             () {
                  //               // _fetchGoods(widget.arguments.nomenklaturaKod);
                  //             },
                  //             (newPhotoUrl) {
                  //               // setState(() {
                  //               //   goods!.photo = newPhotoUrl;
                  //               // });
                  //               _fetchGoods(goods?.nomenklaturaKod ?? "");
                  //               loadProductImages(goods?.nomenklaturaKod ?? "");
                  //             },
                  //           );
                  //         },
                  //         icon: const Icon(Icons.add_photo_alternate_outlined,
                  //             color: Colors.blue),
                  //         label: const Text(
                  //           'Загрузить фото',
                  //           style: TextStyle(color: Colors.blue),
                  //         ),
                  //       ),
                  //       const SizedBox(width: 10),
                  //       TextButton.icon(
                  //         onPressed: () async {
                  //           await Navigator.pushNamed(
                  //             context,
                  //             '/media_delete_page',
                  //             arguments: GoodsArguments(
                  //               'Медиафайлы',
                  //               '',
                  //               '',
                  //               0,
                  //               goods?.nomenklaturaKod ?? "",
                  //             ),
                  //           );

                  //           _fetchGoods(goods?.nomenklaturaKod ?? "");
                  //           loadProductImages(goods?.nomenklaturaKod ?? "");
                  //         },
                  //         icon: const Icon(Icons.delete_outline_rounded,
                  //             color: Colors.red),
                  //         label: const Text(
                  //           'Удалить',
                  //           style: TextStyle(color: Colors.red),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: TextButton.icon(
                  //     onPressed: () {
                  //       uploadVideo(context, goods?.nomenklaturaKod ?? "");
                  //     },
                  //     icon: const Icon(Icons.video_chat_outlined,
                  //         color: Colors.blue),
                  //     label: const Text(
                  //       'Загрузить видео',
                  //       style: TextStyle(color: Colors.blue),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: goods != null
          ? BottomAppBar(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    addToCart(
                        context,
                        convertToSetOrderGoods(goods ?? widget.goods),
                        quantity,
                        goods?.parent);

                    showAlertDialog(
                      context: context,
                      barrierDismissible: true,
                      title: "Уведомление",
                      content: "Товар успешно добавлен в корзину!",
                      actions: <Widget>[
                        CupertinoDialogAction(
                          onPressed: () async {
                            Navigator.pop(context);
                            await Navigator.pushNamed(context, "/cart");
                          },
                          textStyle:
                              const TextStyle(color: AppColors.primaryColor),
                          child: const Text("Перейти в корзину"),
                        ),
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(),
                          textStyle:
                              const TextStyle(color: AppColors.primaryColor),
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Добавить в корзину',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
