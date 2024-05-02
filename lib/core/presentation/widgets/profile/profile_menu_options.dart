import 'package:bismo/app/catalog/catalog_view.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
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
            onTap: () {
             
            },
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Уведомления',
            icon: AppIcons.profileNotification,
            onTap: () {},
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Настройки',
            icon: AppIcons.profileSetting,
            onTap: () {},
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Оплата',
            icon: AppIcons.profilePayment,
            onTap: () {},
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Выйти',
            icon: AppIcons.profileLogout,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
