import 'dart:convert';
import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/user/SignInOtpResponse.dart';
import 'package:bismo/core/models/user/auth_response.dart';
import 'package:bismo/core/models/user/get_profile_response.dart';
import 'package:bismo/core/models/user/register_request.dart';
import 'package:bismo/core/models/user/register_response.dart';
import 'package:dio/dio.dart';

class AuthService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<SingInOtpResponse?> getOtpForSignIn(String phoneNumber) async {
    try {
      Response res = await _http.get(ApiEndpoint.getOtpForSignIn,
          params: {"phone_number": phoneNumber});

      if (res.statusCode == 200 || res.statusCode == 201) {
        SingInOtpResponse response = SingInOtpResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<GetProfileResponse?> getProfile(String phoneNumber) async {
    try {
      var headers = {
        'User': '7777017100',
        'Authorization': 'Basic d2ViOjc3NTc0OTk0NTFkbA=='
      };
      var dio = Dio();
      var response = await dio.request(
        'http://api.bismo.kz/server/hs/all/getprofile',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        // print(json.encode(response.data));
      } else {
        // print(response.statusMessage);
      }

      Options options = Options(headers: {'User': phoneNumber});

      Response res = await _http.get(ApiEndpoint.getProfile, options: options);

      if (res.statusCode == 200 || res.statusCode == 201) {
        GetProfileResponse response = GetProfileResponse.fromJson(res.data);
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

  Future<RegisterResponse?> signUp(RegisterRequest registerRequest) async {
    try {
      Response res = await _http.post(
        ApiEndpoint.register,
        data: jsonEncode(registerRequest),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        RegisterResponse response = RegisterResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
