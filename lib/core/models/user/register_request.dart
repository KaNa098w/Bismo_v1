class RegisterRequest {
  String? email;
  String? password;
  String? phoneNumber;
  String? firstname;

  RegisterRequest(
      {this.email, this.password, this.phoneNumber, this.firstname});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phone_number'];
    firstname = json['firstname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['phone_number'] = phoneNumber;
    data['firstname'] = firstname;
    return data;
  }
}
