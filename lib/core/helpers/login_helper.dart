import 'package:bismo/core/app_cache.dart';
import 'package:bismo/core/classes/route_manager.dart';
import 'package:bismo/core/models/user/auth_response.dart';
import 'package:bismo/core/models/user/get_profile_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void doAuth(BuildContext context, AuthResponse authData) async {
  AppCache ac = AppCache();
  ac.doLogin(authData);
  if (await ac.isLogin()) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Nav.to(context, '/');
    });
  }
}

Future<AuthResponse?> authData() async {
  AppCache ac = AppCache();
  return ac.auth();
}

Future<void> doLogout(BuildContext context) async {
  AppCache ac = AppCache();
  ac.doLogout();
  await checkLogin(context, auth: true);
}

Future<void> checkLogin(
  BuildContext context, {
  bool? auth = false,
  String? loginUrl = "/",
}) async {
  AppCache ac = AppCache();
  await ac.isLogin().then((value) {
    if (value == false && auth! == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Nav.to(context, loginUrl!);
      });
    }
  });
}
