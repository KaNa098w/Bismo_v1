import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/helpers/login_helper.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Добавлено для отправки HTTP-запросов
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:platform/platform.dart';
import 'package:provider/provider.dart';

import 'profile_list_tile.dart';

class ProfileMenuOptions extends StatelessWidget {
  const ProfileMenuOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.padding),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Column(
        children: [
          ProfileListTile(
            title: 'Мой профиль',
            icon: AppIcons.profilePerson,
            onTap: () {
              Navigator.pushNamed(context, '/my_profile');
            },
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Уведомления',
            icon: AppIcons.profileNotification,
            onTap: () {
              Navigator.pushNamed(context, '/notification');
            },
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Настройки',
            icon: AppIcons.profileSetting,
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Выйти',
            icon: AppIcons.profileLogout,
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Подтверждение',
            style: TextStyle(fontSize: 17),
          ),
          content: const Text('Вы уверены, что хотите выйти?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Выйти'),
              onPressed: () {
                Navigator.of(context).pop();
                final platform = LocalPlatform();
                String deviceType = platform.isAndroid
                    ? 'Android'
                    : platform.isIOS
                        ? 'iOS'
                        : 'Unknown';
                Future.microtask(() => _sendLogoutRequest(context,
                    deviceType)); // Передача deviceType с использованием Future.microtask
                doLogout(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendLogoutRequest(
      BuildContext context, String deviceType) async {
    final fCMToken = await FirebaseMessaging.instance.getToken();
    final phoneNumber = context.read<UserProvider>().user?.phoneNumber ?? '';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic d2ViOjc3NTc0OTk0NTFkbA=='
    };
    var data = {
      "login": phoneNumber,
      "device_token": fCMToken,
      "device_type": deviceType, // Использование типа устройства
      "type": "del"
    };

    var dio = Dio();
    var response = await dio.post(
      'http://188.95.95.122:2223/server/hs/all/settoken',
      options: Options(
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print(response.data);
    } else {
      print(response.statusMessage);
    }
  }
}
