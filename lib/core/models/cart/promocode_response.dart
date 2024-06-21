class PromocodeResponse {
  bool? success;
  int? dateLoading;
  String? message;
  int? discount;

  PromocodeResponse(
      {this.success, this.dateLoading, this.message, this.discount});

  PromocodeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    message = json['message'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['date_loading'] = this.dateLoading;
    data['message'] = this.message;
    data['discount'] = this.discount;
    return data;
  }
}
