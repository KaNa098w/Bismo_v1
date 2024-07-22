class GetCategoryUser {
  String? success;
  String? dateLoading;
  List<UserCategories>? categories;

  GetCategoryUser({this.success, this.dateLoading, this.categories});

  GetCategoryUser.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    if (json['categories'] != null) {
      categories = <UserCategories>[];
      json['categories'].forEach((v) {
        categories!.add(new UserCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['date_loading'] = this.dateLoading;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserCategories {
  String? name;
  String? id;

  UserCategories({this.name, this.id});

  UserCategories.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}
