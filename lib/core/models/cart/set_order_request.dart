class SetOrderRequest {
  String? provider;
  int? orderSum;
  String? providerName;
  String? deliveryAddress;
  String? comment;
  String? counterparty;
  String? dolgota;
  String? type;
  String? providerPhoto;
  String? shirota;
  String? user;
  List<Goods>? goods;

  SetOrderRequest(
      {this.provider,
      this.orderSum,
      this.providerName,
      this.deliveryAddress,
      this.comment,
      this.counterparty,
      this.dolgota,
      this.type,
      this.providerPhoto,
      this.shirota,
      this.user,
      this.goods});

  SetOrderRequest.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    orderSum = json['order_sum'];
    providerName = json['provider_name'];
    deliveryAddress = json['Delivery_address'];
    comment = json['comment'];
    counterparty = json['counterparty'];
    dolgota = json['dolgota'];
    type = json['type'];
    providerPhoto = json['provider_photo'];
    shirota = json['shirota'];
    user = json['user'];
    if (json['goods'] != null) {
      goods = <Goods>[];
      json['goods'].forEach((v) {
        goods!.add(Goods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provider'] = provider;
    data['order_sum'] = orderSum;
    data['provider_name'] = providerName;
    data['Delivery_address'] = deliveryAddress;
    data['comment'] = comment;
    data['counterparty'] = counterparty;
    data['dolgota'] = dolgota;
    data['type'] = type;
    data['provider_photo'] = providerPhoto;
    data['shirota'] = shirota;
    data['user'] = user;
    if (goods != null) {
      data['goods'] = goods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Goods {
  String? nomenklaturaKod;
  String? producer;
  int? price;
  int? count;
  int? step;
  String? nomenklatura;
  String? comment;
  int? basketCount;

  Goods(
      {this.nomenklaturaKod,
      this.producer,
      this.price,
      this.count,
      this.step,
      this.nomenklatura,
      this.comment,
      this.basketCount});

  Goods.fromJson(Map<String, dynamic> json) {
    nomenklaturaKod = json['nomenklatura_kod'];
    producer = json['producer'];
    price = json['price'];
    count = json['count'];
    step = json['step'];
    nomenklatura = json['nomenklatura'];
    comment = json['comment'];
    basketCount = json['basket_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomenklatura_kod'] = nomenklaturaKod;
    data['producer'] = producer;
    data['price'] = price;
    data['count'] = count;
    data['step'] = step;
    data['nomenklatura'] = nomenklatura;
    data['comment'] = comment;
    data['basket_count'] = basketCount;
    return data;
  }
}
