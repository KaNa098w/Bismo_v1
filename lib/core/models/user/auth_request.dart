class AuthRequest {
  String email;
  String password;

  AuthRequest({required this.email, required this.password});

  factory AuthRequest.fromJson(Map<String, dynamic> json) {
    return AuthRequest(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
