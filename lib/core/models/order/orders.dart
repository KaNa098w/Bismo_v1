import 'package:bismo/app/profile/my_orders/cart_item.dart';

class Order {
  final String dateLoading;
  final String deliveryAddress;
  final String counterparty;
  final String dolgota;
  final String shirota;
  final String provider;
  final String number;
  final int status;
  final String clientName;
  final String loginProvider;
  final String comment;
  final String user;
  final int orderSum;
  final int factSum;
  final List<CartItem> goods;

  Order({
    required this.dateLoading,
    required this.deliveryAddress,
    required this.counterparty,
    required this.dolgota,
    required this.shirota,
    required this.provider,
    required this.number,
    required this.status,
    required this.clientName,
    required this.loginProvider,
    required this.comment,
    required this.user,
    required this.orderSum,
    required this.factSum,
    required this.goods,
  });

  static Order fromJson(Map<String, dynamic> orderData) {
    return Order(
      dateLoading: orderData['date_loading'] ?? "",
      deliveryAddress: orderData['Delivery_address'] ?? "",
      counterparty: orderData['counterparty'] ?? "",
      dolgota: orderData['dolgota'] ?? "",
      shirota: orderData['shirota'] ?? "",
      provider: orderData['provider'] ?? "",
      number: orderData['number'] ?? "",
      status: orderData['status'] ?? 0,
      clientName: orderData['client_name'] ?? "",
      loginProvider: orderData['login_provider'] ?? "",
      comment: orderData['comment'] ?? "",
      user: orderData['user'] ?? "",
      orderSum: orderData['order_sum'] ?? 0,
      factSum: orderData['fact_sum'] ?? 0,
      goods: _parseGoods(orderData['goods'] ?? []),
    );
  }

  static List<CartItem> _parseGoods(List<dynamic> goodsData) {
    return goodsData.map((data) {
      return CartItem(
        basketCount: data['basket_count'] ?? 0,
        factCount: data['fact_count'] ?? 0,
        kontragent: data['kontragent'] ?? "",
        nomenklatura: data['nomenklatura'] ?? "",
        nomenklaturaKod: data['nomenklatura_kod'] ?? "",
        step: data['step'] ?? 0,
        price: data['price'] ?? 0.0,
        photo: data['photo'] ?? "",
        producer: data['producer'] ?? "",
        comment: data['comment'] ?? "",
      );
    }).toList();
  }
}
