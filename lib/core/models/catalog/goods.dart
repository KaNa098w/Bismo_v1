class GoodsResponse {
  String? success;
  String? dateLoading;
  num? deliverySumm;
  String? categoryClient;
  String? categoryCodeClient;
  List<Goods>? goods;

  GoodsResponse(
      {this.success,
      this.dateLoading,
      this.deliverySumm,
      this.categoryClient,
      this.categoryCodeClient,
      this.goods});

  GoodsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    deliverySumm = json['delivery_summ'];
    categoryClient = json['category_client'];
    categoryCodeClient = json['category_code_client'];
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
    data['category_client'] = categoryClient;
    data['category_code_client'] = categoryCodeClient;
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
  double? price;
  double? optPrice;
  String? kontragent;
  int? step;
  int? newProduct;
  String? photo;
  String? catId;
  double? oldPrice;
  String? newsPhoto;
  String? parent;
  String? parentName;
  List<TypePrice>? typePrice;

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
    this.typePrice,
  });

  Goods.fromJson(Map<String, dynamic> json) {
    nomenklatura = json['nomenklatura'];
    nomenklaturaKod = json['nomenklatura_kod'];
    count = json['count'];
    price = (json['price'] != null) ? json['price'].toDouble() : null;
    optPrice =
        (json['opt_price'] != null) ? json['opt_price'].toDouble() : null;
    kontragent = json['kontragent'];
    step = json['step'];
    newProduct = json['new_product'];
    photo = json['photo'];
    catId = json['cat_id'];
    oldPrice =
        (json['old_price'] != null) ? json['old_price'].toDouble() : null;
    newsPhoto = json['news_photo'];
    parent = json['parent'];
    if (json['type_price'] != null) {
      typePrice = <TypePrice>[];
      json['type_price'].forEach((v) {
        typePrice!.add(TypePrice.fromJson(v));
      });
    }
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
    data['parent_name'] = parentName;
    if (typePrice != null) {
      data['type_price'] = typePrice!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TypePrice {
  String? name;
  double? price;
  String? category;
  String? categoryCode;

  TypePrice({this.name, this.price, this.category, this.categoryCode});

  TypePrice.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = (json['price'] != null) ? json['price'].toDouble() : null;
    category = json['category'];
    categoryCode = json['category_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['price'] = price;
    data['category'] = category;
    data['category_code'] = categoryCode;
    return data;
  }
}
