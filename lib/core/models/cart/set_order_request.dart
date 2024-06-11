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
  List<SetOrderGoods>? goods;

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
      goods = <SetOrderGoods>[];
      json['goods'].forEach((v) {
        goods!.add(SetOrderGoods.fromJson(v));
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

class SetOrderGoods {
  String? nomenklatura;
  String? nomenklaturaKod;
  int? count;
  double? price;
  double? optPrice;
  String? producer;
  String? kontragent;
  int? step;
  int? newProduct;
  String? photo;
  String? catId;
  double? oldPrice;
  String? newsPhoto;

  SetOrderGoods({
    this.nomenklatura,
    this.nomenklaturaKod,
    this.count,
    this.price,
    this.optPrice,
    this.producer,
    this.kontragent,
    this.step,
    this.newProduct,
    this.photo,
    this.catId,
    this.oldPrice,
    this.newsPhoto,
    required comment,
    required int basketCount,
  });

  SetOrderGoods.fromJson(Map<String, dynamic> json) {
    nomenklatura = json['nomenklatura'];
    nomenklaturaKod = json['nomenklatura_kod'];
    count = convertStringToInt(json['count']);
    price = convertStringToDouble(json['price']);
    optPrice = convertStringToDouble(json['opt_price']);
    producer = json['producer'];
    kontragent = json['kontragent'];
    step = convertStringToInt(json['step']);
    newProduct = convertStringToInt(json['new_product']);
    photo = json['photo'];
    catId = json['cat_id'];
    oldPrice = convertStringToDouble(json['old_price']);
    newsPhoto = json['news_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomenklatura'] = nomenklatura;
    data['nomenklatura_kod'] = nomenklaturaKod;
    data['count'] = count;
    data['price'] = price;
    data['opt_price'] = optPrice;
    data['producer'] = producer;
    data['kontragent'] = kontragent;
    data['step'] = step;
    data['new_product'] = newProduct;
    data['photo'] = photo;
    data['cat_id'] = catId;
    data['old_price'] = oldPrice;
    data['news_photo'] = newsPhoto;
    return data;
  }
}

double convertStringToDouble(dynamic value) {
  if (value == null) {
    return 0.0;
  } else if (value is int) {
    return value.toDouble();
  } else if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  } else {
    return 0.0;
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
