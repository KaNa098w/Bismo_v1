import 'dart:convert';
import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/cart/set_order_request.dart';
import 'package:bismo/core/models/cart/set_order_response.dart';
import 'package:dio/dio.dart';

class CartService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<SetOrderResponse?> setOrder(SetOrderRequest request) async {
    try {
      Response res = await _http.post(
        ApiEndpoint.setOrder,
        data: jsonEncode(request),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        SetOrderResponse response = SetOrderResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
