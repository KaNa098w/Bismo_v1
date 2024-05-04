class GetProfileResponse {
  String? success;
  String? dateLoading;
  String? login;
  String? storeName;
  String? name;
  String? lastname;
  int? providerStatus;
  String? type;
  String? photo;

  GetProfileResponse(
      {this.success,
      this.dateLoading,
      this.login,
      this.storeName,
      this.name,
      this.lastname,
      this.providerStatus,
      this.type,
      this.photo});

  GetProfileResponse.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['date_loading'] = dateLoading;
    data['login'] = login;
    data['store_name'] = storeName;
    data['name'] = name;
    data['lastname'] = lastname;
    data['provider_status'] = providerStatus;
    data['type'] = type;
    data['photo'] = photo;
    return data;
  }
}
