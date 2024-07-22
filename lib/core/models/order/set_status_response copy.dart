class SetStatusResponse {
  String? success;
  String? dateLoading;
  String? message;

  SetStatusResponse({this.success, this.dateLoading, this.message});

  SetStatusResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['date_loading'] = dateLoading;
    data['message'] = message;
    return data;
  }
}
