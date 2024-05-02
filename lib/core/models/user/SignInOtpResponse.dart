class SignInOtpResponse {
  String? success;
  String? dateLoading;
  String? smsPw;

  SignInOtpResponse({this.success, this.dateLoading, this.smsPw});

  SignInOtpResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    smsPw = json['sms_pw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['date_loading'] = dateLoading;
    data['sms_pw'] = smsPw;
    return data;
  }
}
