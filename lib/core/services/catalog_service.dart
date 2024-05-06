import 'dart:convert';
import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/user/SignInOtpResponse.dart';
import 'package:bismo/core/models/user/auth_response.dart';
import 'package:bismo/core/models/user/get_profile_response.dart';
import 'package:bismo/core/models/user/register_request.dart';
import 'package:bismo/core/models/user/register_response.dart';
import 'package:dio/dio.dart';

class CatalogService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<CatalogResponse?> getCategories(String catId) async {
    try {
      Response res = await _http.get(ApiEndpoint.getCategories,
          params: {"User": '7757499451', 'provider': '7757499451', 'cat_id':catId});

      if (res.statusCode == 200 || res.statusCode == 201) {
        CatalogResponse response = CatalogResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
