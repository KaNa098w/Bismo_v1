class CategoryResponse {
  String? success;
  String? dateLoading;
  List<Body>? body;

  CategoryResponse({this.success, this.dateLoading, this.body});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    if (json['body'] != null) {
      body = <Body>[];
      json['body'].forEach((v) {
        body!.add(Body.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['date_loading'] = dateLoading;
    if (body != null) {
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Body {
  String? catId;
  String? catName;
  String? provider;
  String? photo;
  bool? haveCategory;

  Body(
      {this.catId, this.catName, this.provider, this.photo, this.haveCategory});

  Body.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'];
    catName = json['cat_name'];
    provider = json['provider'];
    photo = json['photo'];
    haveCategory = json['have_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cat_id'] = catId;
    data['cat_name'] = catName;
    data['provider'] = provider;
    data['photo'] = photo;
    data['have_category'] = haveCategory;
    return data;
  }
}
