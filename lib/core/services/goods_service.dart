import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:dio/dio.dart';

class GoodsService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<GoodsResponse?> getGoods(String catId) async {
    try {
      var res = await _http.get(ApiEndpoint.getGoods, params: {

        "cat_id": catId,  
        'login_provider': '7757499451',
      });

      if (res.statusCode == 200 || res.statusCode == 201) {
        GoodsResponse response = GoodsResponse.fromJson(res.data);
        return response;
      }
    } on DioException catch (e) {
      rethrow;
    }
    return null;
  }
}
