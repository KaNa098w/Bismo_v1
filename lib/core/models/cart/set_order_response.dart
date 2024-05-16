class SetOrderResponse {
  String? success;
  String? uIDOrder;
  String? numberOrder;
  String? message;

  SetOrderResponse(
      {this.success, this.uIDOrder, this.numberOrder, this.message});

  SetOrderResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    uIDOrder = json['UID_Order'];
    numberOrder = json['number_order'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['UID_Order'] = uIDOrder;
    data['number_order'] = numberOrder;
    data['message'] = message;
    return data;
  }
}
