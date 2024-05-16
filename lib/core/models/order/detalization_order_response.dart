class DetalizationOrderResponse {
  String? success;
  String? dateLoading;
  String? deliveryAddress;
  String? counterparty;
  String? dolgota;
  String? shirota;
  String? provider;
  String? number;
  int? status;
  String? clientName;
  String? loginProvider;
  String? comment;
  String? user;
  int? orderSum;
  int? factSum;
  List<Goods>? goods;

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
      this.comment,
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
    comment = json['comment'];
    user = json['user'];
    orderSum = json['order_sum'];
    factSum = json['fact_sum'];
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
    data['Delivery_address'] = deliveryAddress;
    data['counterparty'] = counterparty;
    data['dolgota'] = dolgota;
    data['shirota'] = shirota;
    data['provider'] = provider;
    data['number'] = number;
    data['status'] = status;
    data['client_name'] = clientName;
    data['login_provider'] = loginProvider;
    data['comment'] = comment;
    data['user'] = user;
    data['order_sum'] = orderSum;
    data['fact_sum'] = factSum;
    if (goods != null) {
      data['goods'] = goods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Goods {
  int? basketCount;
  int? factCount;
  String? kontragent;
  String? nomenklatura;
  String? nomenklaturaKod;
  int? step;
  int? price;
  String? photo;
  String? producer;
  String? comment;

  Goods(
      {this.basketCount,
      this.factCount,
      this.kontragent,
      this.nomenklatura,
      this.nomenklaturaKod,
      this.step,
      this.price,
      this.photo,
      this.producer,
      this.comment});

  Goods.fromJson(Map<String, dynamic> json) {
    basketCount = json['basket_count'];
    factCount = json['fact_count'];
    kontragent = json['kontragent'];
    nomenklatura = json['nomenklatura'];
    nomenklaturaKod = json['nomenklatura_kod'];
    step = json['step'];
    price = json['price'];
    photo = json['photo'];
    producer = json['producer'];
    comment = json['comment'];
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
    data['producer'] = producer;
    data['comment'] = comment;
    return data;
  }
}
