class GetMyProfileResponse {
  String? success;
  String? dateLoading;
  String? login;
  String? storeName;
  String? name;
  String? lastname;
  int? providerStatus;
  String? type;
  String? photo;

  GetMyProfileResponse(
      {this.success,
      this.dateLoading,
      this.login,
      this.storeName,
      this.name,
      this.lastname,
      this.providerStatus,
      this.type,
      this.photo});

  GetMyProfileResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    login = json['login'];
    storeName = json['store_name'];
    name = json['name'];
    lastname = json['lastname'];
    providerStatus = json['provider_status'];
    type = json['type'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['date_loading'] = this.dateLoading;
    data['login'] = this.login;
    data['store_name'] = this.storeName;
    data['name'] = this.name;
    data['lastname'] = this.lastname;
    data['provider_status'] = this.providerStatus;
    data['type'] = this.type;
    data['photo'] = this.photo;
    return data;
  }
}
