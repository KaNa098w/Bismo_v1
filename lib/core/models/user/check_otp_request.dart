class CheckOtpRequest {
  String? email;
  String? password;
  String? otp;

  CheckOtpRequest({this.email, this.password, this.otp});

  CheckOtpRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['otp'] = otp;
    return data;
  }
}
