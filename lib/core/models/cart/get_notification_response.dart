class NotificationResponse {
  String? success;
  String? dateLoading;
  String? currentPage;
  List<JSONBody>? jSONBody;

  NotificationResponse(
      {this.success, this.dateLoading, this.currentPage, this.jSONBody});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    currentPage = json['currentPage'];
    if (json['JSON_Body'] != null) {
      jSONBody = <JSONBody>[];
      json['JSON_Body'].forEach((v) {
        jSONBody!.add(new JSONBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['date_loading'] = this.dateLoading;
    data['currentPage'] = this.currentPage;
    if (this.jSONBody != null) {
      data['JSON_Body'] = this.jSONBody!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JSONBody {
  String? user;
  String? message;
  int? typeUser;
  String? photo;

  JSONBody({this.user, this.message, this.typeUser, this.photo});

  JSONBody.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    message = json['message'];
    typeUser = json['type_user'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['message'] = this.message;
    data['type_user'] = this.typeUser;
    data['photo'] = this.photo;
    return data;
  }
}
