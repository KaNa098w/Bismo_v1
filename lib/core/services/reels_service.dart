import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/order/get_new_goods.dart';
import 'package:dio/dio.dart';

class ReelsService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<GetNewGoodsResponse?> getGoods(String phoneNumber) async {
    try {
      Response res = await _http
          .get(ApiEndpoint.newGoods, params: {"login_provider": phoneNumber});

      if (res.statusCode == 200 || res.statusCode == 201) {
        GetNewGoodsResponse response = GetNewGoodsResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
