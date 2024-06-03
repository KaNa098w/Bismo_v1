class SearchCatalogResponse {
  bool? success;
  List<JSONBody>? jSONBody;

  SearchCatalogResponse({this.success, this.jSONBody});

  SearchCatalogResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['JSON_Body'] != null) {
      jSONBody = <JSONBody>[];
      json['JSON_Body'].forEach((v) {
        jSONBody!.add(JSONBody.fromJson(v));
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

class JSONBody {
  String? name;
  String? code;
  String? cateName;
  String? cateId;
  int? quantity;
  bool? group;

  JSONBody(
      {this.name,
      this.code,
      this.cateName,
      this.cateId,
      this.quantity,
      this.group});

  JSONBody.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    cateName = json['cate_name'];
    cateId = json['cate_id'];
    quantity = json['quantity'];
    group = json['group'];
  }

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
