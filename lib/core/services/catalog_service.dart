import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/catalog/category.dart';
import 'package:dio/dio.dart';

class CatalogService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<CategoryResponse?> getCategories(String catId) async {
    try {
      Response res = await _http.get(ApiEndpoint.getCategories, params: {
        "User": '7757499451',
        'provider': '7757499451',
        "cat_id": catId
      });

      if (res.statusCode == 200 || res.statusCode == 201) {
        CategoryResponse response = CategoryResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
