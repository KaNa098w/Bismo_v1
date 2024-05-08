class AuthResponse {
  String? success;
  String? message;
  String? userName;
  String? storeName;
  String? type;

  AuthResponse(
      {this.success, this.message, this.userName, this.storeName, this.type});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    userName = json['user_name'];
    storeName = json['store_name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['user_name'] = userName;
    data['store_name'] = storeName;
    data['type'] = type;
    return data;
  }
}
