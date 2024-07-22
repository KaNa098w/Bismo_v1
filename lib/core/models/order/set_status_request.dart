class SetStatusRequest {
  String? uIDOrder;
  String? user;
  String? status;

  SetStatusRequest({this.uIDOrder, this.user, this.status});

  SetStatusRequest.fromJson(Map<String, dynamic> json) {
    uIDOrder = json['UID_Order'];
    user = json['User'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UID_Order'] = uIDOrder;
    data['User'] = user;
    data['status'] = status;
    return data;
  }
}
