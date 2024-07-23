import 'dart:developer';
import 'dart:io';

import 'package:bismo/core/colors.dart';
import 'package:bismo/core/exceptions.dart';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/dialogs/loader_dialog.dart';
import 'package:bismo/core/presentation/widgets/custom_number_format.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/cart_service.dart';
import 'package:bismo/core/services/promocode_serivice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:bismo/core/models/cart/promocode_response.dart';
import 'package:confetti/confetti.dart';
import 'package:url_launcher/url_launcher.dart';

class PromoCodeBottomSheet extends StatefulWidget {
  final List<PersistentShoppingCartItem> cartItems;
  final Function(BuildContext ctx, List<PersistentShoppingCartItem> items)
      afterOrderCreate;
  final bool isDeliverySelected;

  const PromoCodeBottomSheet(
      {Key? key,
      required this.cartItems,
      required this.isDeliverySelected,
      required this.afterOrderCreate})
      : super(key: key);

  @override
  _PromoCodeBottomSheetState createState() => _PromoCodeBottomSheetState();
}

class _PromoCodeBottomSheetState extends State<PromoCodeBottomSheet>
    with SingleTickerProviderStateMixin {
  bool showPromoInput = false;
  bool showDriverInput = false;
  bool expandContainer = false;
  bool isPaid = false;
  final TextEditingController promoController = TextEditingController();
  final TextEditingController driverPhoneController = TextEditingController();
  final TextEditingController carNumberController = TextEditingController();
  final PromocodeServices _promocodeServices = PromocodeServices();
  double totalAmount = 0.0;
  double discountAmount = 0.0;
  final FocusNode _focusNode = FocusNode();
  bool isInvalidPromo = false;
  bool isValidPromo = false;
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  PromocodeResponse? promocodeResponse;

  Future<void> _launchURL(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _setOrder(
      BuildContext ctx, List<PersistentShoppingCartItem> items) async {
    var userProvider = context.read<UserProvider>();
    showLoader(ctx);
    try {
      int totalPrice = totalAmount.toInt();

      var goods1 = items.map((item) {
        return SetOrderGoods(
          nomenklaturaKod: item.productDetails?['nomenklaturaKod'],
          producer: item.productDetails?['producer'] ?? "",
          price: item.unitPrice,
          count: item.quantity,
          step: item.productDetails?['step'],
          nomenklatura: item.productDetails?['nomenklatura'],
          comment: item.productDetails?['comment'] ?? "Нет комментарии",
          basketCount: item.quantity ?? 1,
        );
      }).toList();

      SetOrderRequest setOrderRequest = SetOrderRequest(
        provider: "provider_code",
        orderSum: totalPrice,
        providerName: "",
        deliveryAddress: userProvider.userAddress?.deliveryAddress,
        comment: '',
        counterparty: "provider_code",
        dolgota: userProvider.userAddress?.dolgota,
        type: widget.isDeliverySelected ? "0" : "1",
        providerPhoto:
            "https://bismo-products.object.pscloud.io/Bismocounterparties/%D0%96%D0%B0%D1%81%D0%9D%D1%83%D1%80.png",
        shirota: userProvider.userAddress?.shirota,
        user: userProvider.user?.phoneNumber,
        goods: goods1,
        promocode: promoController.text,
        promocode_persent: promocodeResponse?.discount,
        driverPhoneNumber: driverPhoneController.text,
        carNumber: carNumberController.text,
      );

      var res = await CartService().setOrder(setOrderRequest);

      if (res != null) {
        if (ctx.mounted) {
          hideLoader(ctx);
          showAlertDialog(
            context: ctx,
            barrierDismissible: false,
            title: "Уведомление",
            content: res.message ?? "",
            actions: <Widget>[
              StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoDialogAction(
                        onPressed: () async {
                          if (!isPaid) {
                            await _launchURL(
                                'https://pay.kaspi.kz/pay/nie157f3');
                            setState(() {
                              isPaid = true;
                            });
                          }
                        },
                        textStyle:
                            const TextStyle(color: AppColors.primaryColor),
                        child: Text(
                            isPaid ? "Оплата ожидается" : "Оплатить заказ"),
                      ),
                      if (isPaid)
                        CupertinoDialogAction(
                          onPressed: () {
                            widget.afterOrderCreate(ctx, items);
                            Navigator.pop(ctx);
                            if (widget.isDeliverySelected) {
                              Navigator.pop(ctx);
                            }
                            Navigator.pushNamed(ctx, "/orders");
                          },
                          textStyle:
                              const TextStyle(color: AppColors.primaryColor),
                          child: const Text("Перейти в мои заказы"),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        }
      }
    } on DioException catch (e) {
      log(e.toString());
      final errorMessage = DioExceptions.fromDioError(e).toString();

      if (ctx.mounted) {
        hideLoader(ctx);
        showAlertDialog(
          context: ctx,
          barrierDismissible: true,
          title: "Ошибка",
          content: errorMessage,
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              textStyle: const TextStyle(color: AppColors.primaryColor),
              child: const Text("OK"),
            ),
          ],
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    totalAmount = widget.cartItems.fold<double>(
      0,
      (total, item) =>
          total +
          (item.unitPrice *
              (item.productDetails?['step'] ?? 1) *
              item.quantity),
    );

    _focusNode.addListener(() {
      setState(() {});
    });

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    promoController.dispose();
    driverPhoneController.dispose();
    carNumberController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _togglePromoInput() {
    setState(() {
      expandContainer = true;
      showDriverInput = false;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        showPromoInput = true;
      });
    });
  }

  void _toggleDriverInput() {
    setState(() {
      expandContainer = true;
      showPromoInput = false;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        showDriverInput = true;
      });
    });
  }

  void _applyPromocode() async {
    String promocodeText = promoController.text.trim();
    if (promocodeText.isNotEmpty) {
      try {
        PromocodeResponse? response =
            await _promocodeServices.getPromoCode(promocodeText);

        promocodeResponse = response;
        if (response != null) {
          if (response.success == true) {
            setState(() {
              discountAmount = (totalAmount * response.discount!) / 100;
              totalAmount -= discountAmount;
              expandContainer = false;
              showPromoInput = false;
              isInvalidPromo = false;
              isValidPromo = true;
              _confettiController.play(); // Запуск анимации салюта
              _animationController.forward(from: 0.0); // Запуск анимации
            });
          } else {
            setState(() {
              isInvalidPromo = true;
              isValidPromo = false;
            });
          }
        } else {
          setState(() {
            isInvalidPromo = true;
            isValidPromo = false;
          });
        }
      } catch (e) {
        setState(() {
          isInvalidPromo = true;
          isValidPromo = false;
        });
      }
    }
  }

  void _cancelPromoInput() {
    setState(() {
      showPromoInput = false;
      promoController.clear();
      expandContainer = false;
      isInvalidPromo = false;
      isValidPromo = false;
    });
  }

  void _cancelDriverInput() {
    setState(() {
      showDriverInput = false;
      driverPhoneController.clear();
      carNumberController.clear();
      expandContainer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();
    double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: expandContainer ? 380 + bottomInset : 320,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 22),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Адрес доставки',
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                userProvider.userAddress?.deliveryAddress != null
                    ? Column(
                        children: [
                          Text(userProvider.userAddress!.deliveryAddress!,
                              style: const TextStyle(fontSize: 16)),
                          InkWell(
                            onTap: () async {
                              await Navigator.pushNamed(context, "/address");
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Выбрать адрес',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: isValidPromo
                                ? Column(
                                    key: const ValueKey<int>(1),
                                    children: [
                                      Text(
                                        'Товары на сумму: ${CustomNumberFormat.format(totalAmount + discountAmount)}₸',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        'Цена 25% скидкой: ${CustomNumberFormat.format(totalAmount)}₸🔥',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Товары на сумму: ${CustomNumberFormat.format(totalAmount)}₸',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                          if (!showPromoInput && !isValidPromo)
                            InkWell(
                              onTap: _togglePromoInput,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Активировать промокод',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          else if (showPromoInput)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: _cancelPromoInput,
                                        child: const Text(
                                          'Отменить',
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: promoController,
                                        focusNode: _focusNode,
                                        decoration: InputDecoration(
                                          hintText: 'Введите промокод',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: isInvalidPromo
                                                  ? Colors.red
                                                  : isValidPromo
                                                      ? Colors.green
                                                      : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send,
                                          color: AppColors.primaryColor),
                                      onPressed: _applyPromocode,
                                    ),
                                  ],
                                ),
                                if (isInvalidPromo)
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Нет такой промокод',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (isValidPromo)
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Промокод активирован',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          if (!showDriverInput)
                            InkWell(
                              onTap: _toggleDriverInput,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Указать данные водителя',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          else if (showDriverInput)
                            Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: driverPhoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      hintText: 'Введите номер телефона',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: carNumberController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      hintText: 'Введите номер машины',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: _cancelDriverInput,
                                        child: const Text(
                                          'Отменить',
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      )
                    : InkWell(
                        onTap: () async {
                          await Navigator.pushNamed(context, "/address");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Выбрать адрес',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(),
                  child: Center(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (userProvider.userAddress?.deliveryAddress ==
                              null) {
                            showAlertDialog(
                              context: context,
                              barrierDismissible: true,
                              title: "Ошибка",
                              content: "Заполните адрес!",
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  onPressed: () => Navigator.of(context).pop(),
                                  textStyle: const TextStyle(
                                      color: AppColors.primaryColor),
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                            return;
                          }
                          _setOrder(context, widget.cartItems);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Оформить заказ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: -3.14 / 2,
                emissionFrequency: 1,
                numberOfParticles: 4,
                gravity: 0.1,
                shouldLoop: false,
                canvas: Size(MediaQuery.of(context).size.width - 50, 2500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
