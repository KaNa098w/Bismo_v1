import 'package:bismo/core/colors.dart';
import 'package:bismo/core/presentation/widgets/custom_number_format.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/promocode_serivice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:bismo/core/models/cart/promocode_response.dart';
import 'package:confetti/confetti.dart';

class PromoCodeBottomSheet extends StatefulWidget {
  final List<PersistentShoppingCartItem> cartItems;

  const PromoCodeBottomSheet({Key? key, required this.cartItems})
      : super(key: key);

  @override
  _PromoCodeBottomSheetState createState() => _PromoCodeBottomSheetState();
}

class _PromoCodeBottomSheetState extends State<PromoCodeBottomSheet>
    with SingleTickerProviderStateMixin {
  bool showPromoInput = false;
  bool expandContainer = false;
  final TextEditingController promoController = TextEditingController();
  final PromocodeServices _promocodeServices = PromocodeServices();
  double totalAmount = 0.0;
  double discountAmount = 0.0;
  final FocusNode _focusNode = FocusNode();
  bool isInvalidPromo = false;
  bool isValidPromo = false;
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _animation;

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
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    promoController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _togglePromoInput() {
    setState(() {
      expandContainer = true;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        showPromoInput = true;
      });
    });
  }

  void _applyPromocode() async {
    String promocodeText = promoController.text.trim();
    if (promocodeText.isNotEmpty) {
      try {
        PromocodeResponse? response =
            await _promocodeServices.getPromoCode(promocodeText);
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

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();
    double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: expandContainer ? 300 + bottomInset : 250,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 22),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Адрес доставки',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                                    key: ValueKey<int>(1),
                                    children: [
                                      Text(
                                        'Товары на сумму: ${CustomNumberFormat.format(totalAmount + discountAmount)}₸',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        'Цена со 25% скидкой: ${CustomNumberFormat.format(totalAmount)}₸',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Товары на сумму: ${CustomNumberFormat.format(totalAmount)}₸',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                          if (!showPromoInput && !isValidPromo)
                            InkWell(
                              onTap: _togglePromoInput,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                        child: Text(
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
                                      icon: Icon(Icons.send,
                                          color: AppColors.primaryColor),
                                      onPressed: _applyPromocode,
                                    ),
                                  ],
                                ),
                                if (isInvalidPromo)
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
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
                                      padding: const EdgeInsets.only(top: 8.0),
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
                            )
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
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                const Spacer(),
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Оформить заказ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
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
                emissionFrequency: 0.5,
                numberOfParticles: 10,
                gravity: 0.1,
                shouldLoop: false,
                canvas: Size(MediaQuery.of(context).size.width - 44, 300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
