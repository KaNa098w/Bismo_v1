class RegisterResponse {
  String? success;
  String? dateLoading;
  String? message;
  String? userName;
  String? storeName;
  String? type;

  RegisterResponse(
      {this.success,
      this.dateLoading,
      this.message,
      this.userName,
      this.storeName,
      this.type});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    message = json['message'];
    userName = json['user_name'];
    storeName = json['store_name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['date_loading'] = dateLoading;
    data['message'] = message;
    data['user_name'] = userName;
    data['store_name'] = storeName;
    data['type'] = type;
    return data;
  }
}
