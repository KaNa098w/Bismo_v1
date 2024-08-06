import 'package:bismo/core/models/catalog/goods.dart';

class SetOrderRequest {
  String? success;
  String? dateLoading;
  num? deliverySumm; // Изменено с int? на num?
  String? categoryClient;
  String? categoryCodeClient;

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
  String? promocode;
  String? driverPhoneNumber;
  String? carNumber;
  int? promocode_persent;
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
      this.goods,
      this.promocode,
      this.driverPhoneNumber,
      this.carNumber,
      this.promocode_persent});

  SetOrderRequest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    deliverySumm = json['delivery_summ'];
    categoryClient = json['category_client'];
    categoryCodeClient = json['category_code_client'];

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
    promocode = json['promocode'];
    carNumber = json['carNumber'];
    driverPhoneNumber = json['driverPhoneNumber'];
    promocode_persent = json['promocode_persent'];
    if (json['goods'] != null) {
      goods = <SetOrderGoods>[];
      json['goods'].forEach((v) {
        goods!.add(SetOrderGoods.fromJson(v));
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
    data['promocode'] = promocode;
    data['carNumber'] = carNumber;
    data['driverPhoneNumber'] = driverPhoneNumber;
    data['promocode_persent'] = promocode_persent;

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
  String? parent;
  String? parentName;
  List<TypePrice>? typePrice;
  String? categoryClient;
  String? categoryCodeClient;
  String? comment;

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
    this.parent,
    this.parentName,
    this.typePrice,
    this.categoryClient,
    this.categoryCodeClient,
    this.comment,
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
    step = json['step'];
    newProduct = convertStringToInt(json['new_product']);
    photo = json['photo'];
    catId = json['cat_id'];
    oldPrice = convertStringToDouble(json['old_price']);
    newsPhoto = json['news_photo'];
    parent = json['parent'];
    parentName = json['parent_name'];
    categoryClient = json['category_client'];
    categoryCodeClient = json['category_code_client'];
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
    data['producer'] = producer;
    data['kontragent'] = kontragent;
    data['step'] = step;
    data['new_product'] = newProduct;
    data['photo'] = photo;
    data['cat_id'] = catId;
    data['old_price'] = oldPrice;
    data['news_photo'] = newsPhoto;
    data['parent'] = parent;
    data['parent_name'] = parentName;
    data['category_client'] = categoryClient;
    data['category_code_client'] = categoryCodeClient;
    if (typePrice != null) {
      data['type_price'] = typePrice!.map((v) => v.toJson()).toList();
    }
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
