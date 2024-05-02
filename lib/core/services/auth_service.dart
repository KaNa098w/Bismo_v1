import 'dart:convert';
import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/user/SignInOtpResponse.dart';
import 'package:bismo/core/models/user/auth_response.dart';
import 'package:dio/dio.dart';

class AuthService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<SignInOtpResponse?> getOtpForSignIn(String phoneNumber) async {
    try {
      Response res = await _http.get(ApiEndpoint.getOtpForSignIn,
          params: {"phone_number": phoneNumber});

      if (res.statusCode == 200 || res.statusCode == 201) {
        SignInOtpResponse response = SignInOtpResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<AuthResponse?> signIn(String phoneNumber, String otp) async {
    try {
      Map<String, dynamic> data = {
        'login': phoneNumber,
        'password': otp,
      };

      Response res = await _http.post(
        ApiEndpoint.login,
        data: jsonEncode(data),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        AuthResponse response = AuthResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
