class GetNewGoodsResponse {
  String? success;
  String? dateLoading;
  int? deliverySumm;
  String? categoryClient;
  String? categoryCodeClient;
  List<Goods>? goods;

  GetNewGoodsResponse(
      {this.success,
      this.dateLoading,
      this.deliverySumm,
      this.categoryClient,
      this.categoryCodeClient,
      this.goods});

  GetNewGoodsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    deliverySumm = json['delivery_summ'];
    categoryClient = json['category_client'];
    categoryCodeClient = json['category_code_client'];
    if (json['goods'] != null) {
      goods = <Goods>[];
      json['goods'].forEach((v) {
        goods!.add(new Goods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['date_loading'] = this.dateLoading;
    data['delivery_summ'] = this.deliverySumm;
    data['category_client'] = this.categoryClient;
    data['category_code_client'] = this.categoryCodeClient;
    if (this.goods != null) {
      data['goods'] = this.goods!.map((v) => v.toJson()).toList();
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
  String? parent;
  String? parentName;
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
      this.newsPhoto,
      this.parent,
      this.parentName,
      this.typePrice});

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
    parent = json['parent'];
    parentName = json['parent_name'];
    if (json['type_price'] != null) {
      typePrice = <TypePrice>[];
      json['type_price'].forEach((v) {
        typePrice!.add(new TypePrice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomenklatura'] = this.nomenklatura;
    data['nomenklatura_kod'] = this.nomenklaturaKod;
    data['count'] = this.count;
    data['price'] = this.price;
    data['opt_price'] = this.optPrice;
    data['kontragent'] = this.kontragent;
    data['step'] = this.step;
    data['new_product'] = this.newProduct;
    data['photo'] = this.photo;
    data['cat_id'] = this.catId;
    data['old_price'] = this.oldPrice;
    data['news_photo'] = this.newsPhoto;
    data['parent'] = this.parent;
    data['parent_name'] = this.parentName;
    if (this.typePrice != null) {
      data['type_price'] = this.typePrice!.map((v) => v.toJson()).toList();
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
    price = json['price'];
    category = json['category'];
    categoryCode = json['category_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['category'] = this.category;
    data['category_code'] = this.categoryCode;
    return data;
  }
}
