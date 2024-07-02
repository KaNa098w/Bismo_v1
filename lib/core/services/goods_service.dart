import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/helpers/login_helper.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:bismo/core/models/user/auth_response.dart';
import 'package:dio/dio.dart';

class GoodsService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<GoodsResponse?> getGoods(String catId) async {
    try {
      AuthResponse? authResponse = await authData();

      final url =
          '${ApiEndpoint.getGoods}?login_provider=7757499451&cat_id=$catId&user=${authResponse?.phoneNumber}';
      print('*** Request ***');
      print('uri: $url');
      print('method: GET');

      final response = await _http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        GoodsResponse goodsResponse = GoodsResponse.fromJson(response.data);
        return goodsResponse;
      } else {
        throw Exception(
            'Failed to load goods. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Error fetching goods: $e');
      rethrow;
    }
  }

  Future<GoodsResponse?> getGood(String nomenklaturaKod) async {
    AuthResponse? authResponse = await authData();

    try {
      final url =
          '${ApiEndpoint.getGoods}?nomenklature_kod=$nomenklaturaKod&user=${authResponse?.phoneNumber}';
      print('*** Request ***');
      print('uri: $url');
      print('method: GET');

      final response = await _http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        GoodsResponse goodsResponse = GoodsResponse.fromJson(response.data);
        return goodsResponse;
      } else {
        throw Exception(
            'Failed to load goods. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Error fetching goods: $e');
      rethrow;
    }
  }
}
