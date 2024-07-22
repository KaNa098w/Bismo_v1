class DetalizationOrderResponse {
  String? success;
  int? dateLoading;
  String? deliveryAddress;
  String? counterparty;
  String? dolgota;
  String? shirota;
  String? provider;
  String? number;
  int? status;
  String? clientName;
  String? loginProvider;
  String? user;
  int? orderSum;
  int? factSum;
  List<OrderGoods>? goods;

  DetalizationOrderResponse(
      {this.success,
      this.dateLoading,
      this.deliveryAddress,
      this.counterparty,
      this.dolgota,
      this.shirota,
      this.provider,
      this.number,
      this.status,
      this.clientName,
      this.loginProvider,
      this.user,
      this.orderSum,
      this.factSum,
      this.goods});

  DetalizationOrderResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    deliveryAddress = json['Delivery_address'];
    counterparty = json['counterparty'];
    dolgota = json['dolgota'];
    shirota = json['shirota'];
    provider = json['provider'];
    number = json['number'];
    status = json['status'];
    clientName = json['client_name'];
    loginProvider = json['login_provider'];
    user = json['user'];
    orderSum = json['order_sum'];
    factSum = json['fact_sum'];
    if (json['goods'] != null) {
      goods = <OrderGoods>[];
      json['goods'].forEach((v) {
        goods!.add(OrderGoods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['date_loading'] = dateLoading;
    data['Delivery_address'] = deliveryAddress;
    data['counterparty'] = counterparty;
    data['dolgota'] = dolgota;
    data['shirota'] = shirota;
    data['provider'] = provider;
    data['number'] = number;
    data['status'] = status;
    data['client_name'] = clientName;
    data['login_provider'] = loginProvider;
    data['user'] = user;
    data['order_sum'] = orderSum;
    data['fact_sum'] = factSum;
    if (goods != null) {
      data['goods'] = goods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderGoods {
  int? basketCount;
  int? factCount;
  String? kontragent;
  String? nomenklatura;
  String? nomenklaturaKod;
  int? step;
  int? price;
  String? photo;

  OrderGoods(
      {this.basketCount,
      this.factCount,
      this.kontragent,
      this.nomenklatura,
      this.nomenklaturaKod,
      this.step,
      this.price,
      this.photo});

  OrderGoods.fromJson(Map<String, dynamic> json) {
    basketCount = json['basket_count'];
    factCount = json['fact_count'];
    kontragent = json['kontragent'];
    nomenklatura = json['nomenklatura'];
    nomenklaturaKod = json['nomenklatura_kod'];
    step = json['step'];
    price = json['price'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['basket_count'] = basketCount;
    data['fact_count'] = factCount;
    data['kontragent'] = kontragent;
    data['nomenklatura'] = nomenklatura;
    data['nomenklatura_kod'] = nomenklaturaKod;
    data['step'] = step;
    data['price'] = price;
    data['photo'] = photo;
    return data;
  }
}
