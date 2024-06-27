import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/user/get_address_response.dart';
import 'package:bismo/core/models/user/get_category_user_response.dart';
import 'package:bismo/core/models/user/get_my_profile_response.dart';
import 'package:dio/dio.dart';

class UserService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<GetAddressResponse?> getUserAddress(String phoneNumber) async {
    try {
      Response res = await _http
          .get(ApiEndpoint.getAddress, params: {"phone_number": phoneNumber});

      if (res.statusCode == 200 || res.statusCode == 201) {
        GetAddressResponse response = GetAddressResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<GetCategoryUser?> getUserCategory(String user) async {
    try {
      Response res = await _http
          .get(ApiEndpoint.userCategory, params: {"phone_number": user});

      if (res.statusCode == 200 || res.statusCode == 201) {
        GetCategoryUser response = GetCategoryUser.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
