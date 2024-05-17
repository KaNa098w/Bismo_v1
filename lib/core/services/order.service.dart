import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/order/detalization_order_response.dart';
import 'package:bismo/core/models/order/get_my_order_list_response.dart';
import 'package:dio/dio.dart';

class OrderService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<DetalizationOrderResponse?> getDetalizationsOrder(
      String phoneNumber, String uid) async {
    try {
      Response res = await _http.get(ApiEndpoint.detalizationsOrder,
          params: {"UID": uid, "user": phoneNumber});

      if (res.statusCode == 200 || res.statusCode == 201) {
        DetalizationOrderResponse response =
            DetalizationOrderResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<GetMyOrderListResponse?> getMyOrdersList(
      String phoneNumber, String page) async {
    try {
      Response res = await _http.get(ApiEndpoint.getmyordersList,
          params: {"user": phoneNumber, "page": page});

      if (res.statusCode == 200 || res.statusCode == 201) {
        GetMyOrderListResponse response =
            GetMyOrderListResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
