import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:dio/dio.dart';

class GoodsSerVice {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<GoodsResponse?> getCategories(String catId) async {
    try {
      Response res = await _http.get(ApiEndpoint.getCategories, params: {
        "User": '7757499452',
        'provider': '7757499451',
        "cat_id": catId
      });

      if (res.statusCode == 200 || res.statusCode == 201) {
        GoodsResponse response = GoodsResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
