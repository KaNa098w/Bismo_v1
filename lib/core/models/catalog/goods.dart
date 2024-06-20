class GoodsResponse {
  String? success;
  String? dateLoading;
  num? deliverySumm; // Изменено с int? на num?
  List<Goods>? goods;

  GoodsResponse(
      {this.success, this.dateLoading, this.deliverySumm, this.goods});

  GoodsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    deliverySumm = json['delivery_summ'];
    if (json['goods'] != null) {
      goods = <Goods>[];
      json['goods'].forEach((v) {
        goods!.add(Goods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['date_loading'] = dateLoading;
    data['delivery_summ'] = deliverySumm;
    if (goods != null) {
      data['goods'] = goods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Goods {
  String? nomenklatura;
  String? nomenklaturaKod;
  String? count;
  num? price; // Изменено с int? на num?
  num? optPrice; // Изменено с int? на num?
  String? kontragent;
  int? step;
  int? newProduct;
  String? photo;
  String? catId;
  num? oldPrice; // Изменено с int? на num?
  String? newsPhoto;
  String? parent;

  Goods({
    this.nomenklatura,
    this.nomenklaturaKod,
    this.count,
    this.price,
    this.optPrice,
    this.kontragent,
    this.step,
    this.newProduct,
    this.photo,
    this.catId,
    this.oldPrice,
    this.parent,
    this.newsPhoto,
  });

  Goods.fromJson(Map<String, dynamic> json) {
    nomenklatura = json['nomenklatura'];
    nomenklaturaKod = json['nomenklatura_kod'];
    count = json['count'];
    price = json['price'] is int
        ? json['price']
        : (json['price'] as double).toInt();
    optPrice = json['opt_price'] is int
        ? json['opt_price']
        : (json['opt_price'] as double).toInt();
    kontragent = json['kontragent'];
    step = json['step'];
    newProduct = json['new_product'];
    photo = json['photo'];
    catId = json['cat_id'];
    oldPrice = json['old_price'] is int
        ? json['old_price']
        : (json['old_price'] as double).toInt();
    newsPhoto = json['news_photo'];
    parent = json['parent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['nomenklatura'] = nomenklatura;
    data['nomenklatura_kod'] = nomenklaturaKod;
    data['count'] = count;
    data['price'] = price;
    data['opt_price'] = optPrice;
    data['kontragent'] = kontragent;
    data['step'] = step;
    data['new_product'] = newProduct;
    data['photo'] = photo;
    data['cat_id'] = catId;
    data['old_price'] = oldPrice;
    data['news_photo'] = newsPhoto;
    data['parent'] = parent;
    return data;
  }
}
