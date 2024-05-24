import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/helpers/login_helper.dart';
import 'package:flutter/material.dart';

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
            onTap: () {},
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
                doLogout(context);
              },
            ),
          ],
        );
      },
    );
  }
}
