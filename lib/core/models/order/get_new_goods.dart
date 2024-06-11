class GetNewGoodsResponse {
  String? success;
  String? dateLoading;
  int? deliverySumm;
  List<Goods>? goods;

  GetNewGoodsResponse(
      {this.success, this.dateLoading, this.deliverySumm, this.goods});

  GetNewGoodsResponse.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
  int? price;
  int? optPrice;
  String? kontragent;
  int? step;
  int? newProduct;
  String? photo;
  String? catId;
  int? oldPrice;
  String? newsPhoto;

  Goods(
      {this.nomenklatura,
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
      this.newsPhoto});

  Goods.fromJson(Map<String, dynamic> json) {
    nomenklatura = json['nomenklatura'];
    nomenklaturaKod = json['nomenklatura_kod'];
    count = json['count'];
    price = json['price'];
    optPrice = json['opt_price'];
    kontragent = json['kontragent'];
    step = json['step'];
    newProduct = json['new_product'];
    photo = json['photo'];
    catId = json['cat_id'];
    oldPrice = json['old_price'];
    newsPhoto = json['news_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    return data;
  }
}
