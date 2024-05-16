class GetMyOrderListResponse {
  String? success;
  String? dateLoading;
  String? currentPage;
  List<JSONBody>? jSONBody;

  GetMyOrderListResponse(
      {this.success, this.dateLoading, this.currentPage, this.jSONBody});

  GetMyOrderListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    currentPage = json['currentPage'];
    if (json['JSON_Body'] != null) {
      jSONBody = <JSONBody>[];
      json['JSON_Body'].forEach((v) {
        jSONBody!.add(JSONBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['date_loading'] = dateLoading;
    data['currentPage'] = currentPage;
    if (jSONBody != null) {
      data['JSON_Body'] = jSONBody!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JSONBody {
  String? number;
  String? date;
  String? uIDOrder;
  String? sumOrder;
  String? factSum;
  String? providerName;
  String? photo;
  int? status;

  JSONBody(
      {this.number,
      this.date,
      this.uIDOrder,
      this.sumOrder,
      this.factSum,
      this.providerName,
      this.photo,
      this.status});

  JSONBody.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    date = json['date'];
    uIDOrder = json['UID_Order'];
    sumOrder = json['sum_Order'];
    factSum = json['fact_sum'];
    providerName = json['provider_name'];
    photo = json['photo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['date'] = date;
    data['UID_Order'] = uIDOrder;
    data['sum_Order'] = sumOrder;
    data['fact_sum'] = factSum;
    data['provider_name'] = providerName;
    data['photo'] = photo;
    data['status'] = status;
    return data;
  }
}
