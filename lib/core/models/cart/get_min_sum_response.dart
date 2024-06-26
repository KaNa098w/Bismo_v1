class GetMinSumResponse {
  int? dateLoading;
  String? message;
  List<Body>? body;

  GetMinSumResponse({this.dateLoading, this.message, this.body});

  GetMinSumResponse.fromJson(Map<String, dynamic> json) {
    dateLoading = json['date_loading'];
    message = json['message'];
    if (json['body'] != null) {
      body = <Body>[];
      json['body'].forEach((v) {
        body!.add(new Body.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_loading'] = this.dateLoading;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Body {
  String? parent;
  int? summ;

  Body({this.parent, this.summ});

  Body.fromJson(Map<String, dynamic> json) {
    parent = json['parent'];
    summ = json['summ'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parent'] = this.parent;
    data['summ'] = this.summ;
    return data;
  }
}
