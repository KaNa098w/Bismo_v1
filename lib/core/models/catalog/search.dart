class SearchCatalogResponse {
  bool? success;
  List<SearchResultItems>? jSONBody;

  SearchCatalogResponse({this.success, this.jSONBody});

  SearchCatalogResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['JSON_Body'] != null) {
      jSONBody = <SearchResultItems>[];
      json['JSON_Body'].forEach((v) {
        jSONBody!.add(SearchResultItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (jSONBody != null) {
      data['JSON_Body'] = jSONBody!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchResultItems {
  String? name;
  String? code;
  String? cateName;
  String? cateId;
  int? quantity;
  bool? group;

  SearchResultItems(
      {this.name,
      this.code,
      this.cateName,
      this.cateId,
      this.quantity,
      this.group});

  SearchResultItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    cateName = json['cate_name'];
    cateId = json['cate_id'];
    quantity = json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']);
    group = json['group'];
  }

  get catId => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['cate_name'] = cateName;
    data['cate_id'] = cateId;
    data['quantity'] = quantity;
    data['group'] = group;
    return data;
  }
}
