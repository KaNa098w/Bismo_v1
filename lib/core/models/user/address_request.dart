class AddressRequest {
  String? deliveryAddress;
  String? dolgota;
  String? shirota;

  AddressRequest({this.deliveryAddress, this.dolgota, this.shirota});

  AddressRequest.fromJson(Map<String, dynamic> json) {
    deliveryAddress = json['Delivery_address'];
    dolgota = json['dolgota'];
    shirota = json['shirota'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Delivery_address'] = deliveryAddress;
    data['dolgota'] = dolgota;
    data['shirota'] = shirota;
    return data;
  }
}
