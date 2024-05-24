import 'dart:convert';
import 'dart:developer';
import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/user/SignInOtpResponse.dart';
import 'package:bismo/core/models/user/add_address_response.dart';
import 'package:bismo/core/models/user/address_request.dart';
import 'package:bismo/core/models/user/auth_response.dart';
import 'package:bismo/core/models/user/delete_address_response.dart';
// import 'package:bismo/core/models/user/delete_address_response.dart';
import 'package:bismo/core/models/user/get_address_response.dart';
import 'package:bismo/core/models/user/get_profile_response.dart';
import 'package:bismo/core/models/user/register_request.dart';
import 'package:bismo/core/models/user/register_response.dart';
import 'package:dio/dio.dart';

class AddressService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<GetAddressResponse?> getAddresses(String phoneNumber) async {
    try {
      Response res = await _http
          .get(ApiEndpoint.getAddresses, params: {"phone_number": phoneNumber});

      if (res.statusCode == 200 || res.statusCode == 201) {
        GetAddressResponse response = GetAddressResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<AddAddressResponse?> addAddress(
      AddressRequest addressRequest, String phoneNumber) async {
    try {
      Options options = Options(headers: {'User': phoneNumber});
      Response res = await _http.post(ApiEndpoint.addAddress,
          data: jsonEncode(addressRequest), options: options);

      if (res.statusCode == 200 || res.statusCode == 201) {
        AddAddressResponse response = AddAddressResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

 Future<DeleteAddressResponse?> deleteAddress(String phoneNumber, String deliveryAddress) async {
    try {
      log('Deleting address with phone number: $phoneNumber and delivery address: $deliveryAddress');
      Response res = await _http.delete(
        ApiEndpoint.deleteAddress,
        params: {"user": phoneNumber, "Delivery_address": deliveryAddress},
      );

      if (res.statusCode == 200 || res.statusCode == 204) {
        DeleteAddressResponse response = DeleteAddressResponse.fromJson(res.data);
        return response;
      }
    } catch (e) {
      log('Error during deleteAddress: $e');
      rethrow;
    }
    return null;
  }


}
