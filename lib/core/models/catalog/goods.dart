import 'package:bismo/core/models/cart/set_order_request.dart';

class GoodsResponse {
  String? success;
  String? dateLoading;
  int? deliverySumm;
  String? kontragent;
  String? showCount;
  String? adressProvider;
  List<Goods>? goods;

  GoodsResponse({
    this.success,
    this.dateLoading,
    this.deliverySumm,
    this.kontragent,
    this.showCount,
    this.adressProvider,
    this.goods,
  });

  GoodsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    dateLoading = json['date_loading'];
    deliverySumm = convertStringToInt(json['delivery_summ']);
    kontragent = json['kontragent'];
    showCount = json['show_count'];
    adressProvider = json['adress_provider'];
    if (json['goods'] != null) {
      goods = <Goods>[];
      json['goods'].forEach((v) {
        goods!.add(Goods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['date_loading'] = dateLoading;
    data['delivery_summ'] = deliverySumm;
    data['kontragent'] = kontragent;
    data['show_count'] = showCount;
    data['adress_provider'] = adressProvider;
    if (goods != null) {
      data['goods'] = goods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

int convertStringToInt(dynamic value) {
  if (value == null) {
    return 0;
  } else if (value is int) {
    return value;
  } else if (value is String) {
    try {
      return int.parse(value);
    } catch (e) {
      return 0;
    }
  } else {
    return 0;
  }
}
