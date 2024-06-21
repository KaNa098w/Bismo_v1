import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/cart/promocode_response.dart';
import 'package:dio/dio.dart';

class PromocodeServices {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<PromocodeResponse?> getPromoCode(String promocodeText) async {
    try {
      Response res = await _http
          .get(ApiEndpoint.promocode, params: {"code": promocodeText});

      if (res.statusCode == 200 || res.statusCode == 201) {
        PromocodeResponse response = PromocodeResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
