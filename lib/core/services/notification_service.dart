import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/helpers/login_helper.dart';
import 'package:bismo/core/models/cart/get_notification_response.dart';
import 'package:bismo/core/models/user/auth_response.dart';
import 'package:dio/dio.dart';

class NotificationServices {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<NotificationResponse?> getNotifications(String phoneNumber) async {
    try {
      AuthResponse? authResponse = await authData();
      phoneNumber = authResponse!.phoneNumber!;
      Response res = await _http.get(ApiEndpoint.getNotifications,
          params: {"user": phoneNumber, "type": '1', "page": '1'});

      if (res.statusCode == 200 || res.statusCode == 201) {
        NotificationResponse response = NotificationResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
