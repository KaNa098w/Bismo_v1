class GetAddressResponse {
  String? success;
  String? dateLoading;
  List<AllAdress>? allAdress;

  GetAddressResponse({this.success, this.dateLoading, this.allAdress});

  GetAddressResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    dateLoading = json['date_loading'];
    if (json['all_adress'] != null) {
      allAdress = <AllAdress>[];
      json['all_adress'].forEach((v) {
        allAdress!.add(AllAdress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['date_loading'] = dateLoading;
    if (allAdress != null) {
      data['all_adress'] = allAdress!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllAdress {
  String? adres;
  String? dolgota;
  String? shirota;

  AllAdress({this.adres, this.dolgota, this.shirota});

  AllAdress.fromJson(Map<String, dynamic> json) {
    adres = json['adres'];
    dolgota = json['dolgota'];
    shirota = json['shirota'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adres'] = adres;
    data['dolgota'] = dolgota;
    data['shirota'] = shirota;
    return data;
  }
}
