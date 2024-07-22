class GoodsResponse {
  String? success;
  String? dateLoading;
  num? deliverySumm; // Изменено с int? на num?
  List<Goods>? goods;
  String? categoryClient;
  String? categoryCodeClient;

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
    final Map<String, dynamic> data = <String, dynamic>{};
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
  String? parentName;
  bool? calculation;
  List<TypePrice>? typePrice;

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
      this.parent,
      this.newsPhoto,
      this.parentName,
      this.calculation,
      this.typePrice});

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
    parentName = json['parent_name'];
    calculation = json['calculation'];
    if (json['type_price'] != null) {
      typePrice = <TypePrice>[];
      json['type_price'].forEach((v) {
        typePrice!.add(TypePrice.fromJson(v));
      });
    }
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
    data['parent'] = parent;
    data['parent_name'] = parentName;
    data['calculation'] = calculation;

    if (typePrice != null) {
      data['type_price'] = typePrice!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TypePrice {
  String? name;
  int? price;
  String? category;
  String? categoryCode;

  TypePrice({this.name, this.price, this.category, this.categoryCode});

  TypePrice.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'] is int
        ? json['price']
        : (json['price'] as double).toInt();
    category = json['category'];
    categoryCode = json['category_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['category'] = category;
    data['category_code'] = categoryCode;
    return data;
  }
}
