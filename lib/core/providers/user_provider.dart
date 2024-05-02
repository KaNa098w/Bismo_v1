import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/exceptions.dart';
import 'package:bismo/core/helpers/login_helper.dart';
import 'package:bismo/core/models/user/auth_response.dart';
import 'package:bismo/core/models/user/oauth2_token_info.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/dialogs/loader_dialog.dart';
import 'package:bismo/core/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool _isLogin = false;
  bool get isLogin => _isLogin;
  bool resetSuccess = false;
  int _resetTimerCountdown = 59;
  int get resetTimerCountdown => _resetTimerCountdown;
  bool _isButtonDisabled = false;
  bool get isButtonDisabled => _isButtonDisabled;
  Timer? _timer;

  AuthResponse? _user;
  AuthResponse? get user => _user;

  late Oauth2TokenInfo? _oauth2TokenInfo;
  Oauth2TokenInfo? get oauth2TokenInfo => _oauth2TokenInfo;

  UserProvider(AuthResponse? authResponse) {
    if (authResponse == null) return;
    _user = authResponse;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  // void setSelectedPoint(LatLng? value) {
  //   _selectedAddressPoint = value;
  //   notifyListeners();
  // }

  void setInitData(AuthResponse? data) {
    _user = data;
    notifyListeners();
  }

  void decrementCountdown() {
    if (_resetTimerCountdown > 0) {
      _resetTimerCountdown--;
      notifyListeners();
    }
  }

  void resetCountdown() {
    _resetTimerCountdown = 60;
    notifyListeners();
  }

  void startTimer() {
    _isButtonDisabled = true;
    _resetTimerCountdown = 60;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resetTimerCountdown > 0) {
        _resetTimerCountdown--;
        notifyListeners();
      } else {
        _isButtonDisabled = false;
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  void logout(BuildContext ctx) {
    doLogout(ctx);
    _user = null;
    _oauth2TokenInfo = null;
  }

  Future<bool> getOtpForSignIn(String phoneNumber, BuildContext ctx) async {
    showLoader(ctx);
    try {
      var res = await AuthService().getOtpForSignIn(phoneNumber);

      print(res?.toJson());

      if (res != null) {
        if ((res.success ?? false) == false) {
          if (ctx.mounted) {
            hideLoader(ctx);
            showAlertDialog(
              context: ctx,
              barrierDismissible: true,
              title: "Ошибка",
              content: "Неправильный номер телефона",
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(ctx).pop(),
                  textStyle: const TextStyle(color: AppColors.primaryColor),
                  child: const Text("OK"),
                ),
              ],
            );
          }

          return false;
        }

        if (ctx.mounted) {
          hideLoader(ctx);
        }

        return true;
      }
    } on DioError catch (e) {
      log(e.toString());
      final errorMessage = DioExceptions.fromDioError(e).toString();
      if (e.response?.statusCode == 401) {
        if (ctx.mounted) {
          hideLoader(ctx);
          showAlertDialog(
            context: ctx,
            barrierDismissible: true,
            title: "Ошибка",
            content: "Неправильный номер телефона или пароль",
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                textStyle: const TextStyle(color: AppColors.primaryColor),
                child: const Text("OK"),
              ),
            ],
          );
        }
      } else {
        if (ctx.mounted) {
          hideLoader(ctx);
          showAlertDialog(
            context: ctx,
            barrierDismissible: true,
            title: "Ошибка",
            content: errorMessage,
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                textStyle: const TextStyle(color: AppColors.primaryColor),
                child: const Text("OK"),
              ),
            ],
          );
        }
      }

      return false;
    }

    return false;
  }

  Future<bool> signIn(String phoneNumber, String otp, BuildContext ctx) async {
    showLoader(ctx);
    try {
      var res = await AuthService().signIn(phoneNumber, otp);

      if (res != null) {
        if ((res.success ?? false) == false) {
          if (ctx.mounted) {
            hideLoader(ctx);
            showAlertDialog(
              context: ctx,
              barrierDismissible: true,
              title: "Ошибка",
              content: "Неправильный код",
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(ctx).pop(),
                  textStyle: const TextStyle(color: AppColors.primaryColor),
                  child: const Text("OK"),
                ),
              ],
            );
          }

          return false;
        }

        if (ctx.mounted) {
          _user = res;
          doAuth(ctx, res);
          hideLoader(ctx);
          notifyListeners();
        }

        return true;
      }
    } on DioError catch (e) {
      log(e.toString());
      final errorMessage = DioExceptions.fromDioError(e).toString();
      if (e.response?.statusCode == 401) {
        if (ctx.mounted) {
          hideLoader(ctx);
          showAlertDialog(
            context: ctx,
            barrierDismissible: true,
            title: "Ошибка",
            content: "Неправильный логин или пароль",
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                textStyle: const TextStyle(color: AppColors.primaryColor),
                child: const Text("OK"),
              ),
            ],
          );
        }
      } else {
        if (ctx.mounted) {
          hideLoader(ctx);
          showAlertDialog(
            context: ctx,
            barrierDismissible: true,
            title: "Ошибка",
            content: errorMessage,
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                textStyle: const TextStyle(color: AppColors.primaryColor),
                child: const Text("OK"),
              ),
            ],
          );
        }
      }

      return false;
    }

    return false;
  }
}
