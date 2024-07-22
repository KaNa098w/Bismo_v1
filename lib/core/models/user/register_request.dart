class RegisterRequest {
  String? name;
  String? lastName;
  String? login;
  String? nameStore;
  String? typeStore;
  List<Categories>? categories;

  RegisterRequest(
      {this.name,
      this.lastName,
      this.login,
      this.nameStore,
      this.typeStore,
      this.categories});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lastName = json['last_name'];
    login = json['login'];
    nameStore = json['name_store'];
    typeStore = json['type_store'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['last_name'] = lastName;
    data['login'] = login;
    data['name_store'] = nameStore;
    data['type_store'] = typeStore;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? id;

  Categories({this.id});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
