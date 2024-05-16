import 'dart:convert';
import 'package:bismo/core/classes/cache_manager.dart';
import 'package:bismo/core/models/user/auth_response.dart';
import 'package:bismo/core/models/user/oauth2_token_info.dart';

class AppCache {
  Map<String, String>? udata;

  void doLogin(AuthResponse response) {
    // Cache.saveData('auth_data', response.toJson());

    // Map<String, dynamic> data = response.toJson();
    // Cache.saveData('auth_data', jsonEncode(data));
    Cache.saveData('auth_data', jsonEncode(response.toJson()));
  }

  Future<AuthResponse?> auth() async {
    var data = await Cache.readData('auth_data');
    if (data == null) return null;

    AuthResponse authResponse = AuthResponse.fromJson(jsonDecode(data));

    return authResponse;

    // return AuthResponse.fromJson(jsonDecode(data));
  }

  Future<Oauth2TokenInfo?> getTokens() async {
    var tokens = await Cache.readData('tokens');
    if (tokens == null) return null;

    return Oauth2TokenInfo.fromJson(jsonDecode(tokens));
  }

  Future<bool> isLogin() async {
    var data = await Cache.readData('auth_data');

    try {
      if (data != null) {
        // var tokens = await Cache.readData('tokens');
        // var tokensList = Oauth2TokenInfo.fromJson(jsonDecode(tokens));
        // if (isTokenExpired(tokensList.accessToken ?? "")) {
        //   return false;
        // }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // bool isTokenExpired(String token) {
  //   try {
  //     final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  //     final int exp = decodedToken['exp'];
  //     final int currentTimeInSeconds =
  //         DateTime.now().millisecondsSinceEpoch ~/ 1000;

  //     return exp < currentTimeInSeconds;
  //   } catch (e) {
  //     return true;
  //   }
  // }

  void doLogout() {
    Cache.deleteData('auth_data');
    Cache.deleteData('tokens');
  }

  Future<bool> isLogout() async {
    var data = await Cache.readData('auth_data');
    if (data == null) {
      return true;
    }
    return false;
  }
}
