class GoodsResponse {
  String? success;
  String? dateLoading;
  int? deliverySumm;
  String? kontragent;
  String? showCount;
  String? adressProvider;
  List<Goods>? goods;

  GoodsResponse(
      {this.success,
      this.dateLoading,
      this.deliverySumm,
      this.kontragent,
      this.showCount,
      this.adressProvider,
      this.goods});

  GoodsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    deliverySumm = (json['delivery_summ']);
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

class Goods {
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

  Goods(
      {this.nomenklatura,
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
      this.newsPhoto});

  Goods.fromJson(Map<String, dynamic> json) {
    nomenklatura = json['nomenklatura'];
    nomenklaturaKod = json['nomenklatura_kod'];
    count = json['count'];
    price = convertStringToDouble(json['price']);
    optPrice = convertStringToDouble(json['opt_price']);
    producer = json['producer'];
    kontragent = json['kontragent'];
    step = json['step'];
    newProduct = json['new_product'];
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