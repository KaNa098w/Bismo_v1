class CatalogResponse {
  String? success;
  String? dateLoading;
  String? smsPw;

  CatalogResponse({this.success, this.dateLoading, this.smsPw});

  CatalogResponse.fromJson(Map<String, dynamic> json) {
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
