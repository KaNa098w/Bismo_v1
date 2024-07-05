class DeleteUserAccountResponse {
  String? success;
  String? dateLoading;
  String? message;

  DeleteUserAccountResponse({this.success, this.dateLoading, this.message});

  DeleteUserAccountResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['date_loading'] = this.dateLoading;
    data['message'] = this.message;
    return data;
  }
}
