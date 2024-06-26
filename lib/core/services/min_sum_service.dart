import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/cart/get_min_sum_response.dart';
import 'package:bismo/core/models/order/get_new_goods.dart';
import 'package:dio/dio.dart';

class MinSummService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<GetMinSumResponse?> getMinSum(String phoneNumber) async {
    try {
      Response res = await _http.get(ApiEndpoint.getMinSum);

      if (res.statusCode == 200 || res.statusCode == 201) {
        GetMinSumResponse response = GetMinSumResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
