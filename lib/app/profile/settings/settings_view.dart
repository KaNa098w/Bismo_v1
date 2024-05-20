import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/presentation/components/app_settings_tile.dart';
import 'package:bismo/core/presentation/components/orders_comp/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsView extends StatefulWidget {
  final String? title;

  const SettingsView({Key? key, this.title}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Настройки',
        ),
      ),
      backgroundColor: AppColors.cardColor,
      body: Container(
        margin: const EdgeInsets.all(AppDefaults.padding),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDefaults.padding,
          vertical: AppDefaults.padding * 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: AppDefaults.borderRadius,
        ),
        child: Column(
          children: [
            AppSettingsListTile(
              label: 'Язык',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () {
                // Navigator.pushNamed(context, AppRoutes.settingsLanguage);
              },
            ),
            AppSettingsListTile(
              label: 'Уведомления',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () {
                // Navigator.pushNamed(context, AppRoutes.settingsNotifications);
              },
            ),
            AppSettingsListTile(
              label: 'Изменить пароль',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () {
                // Navigator.pushNamed(context, AppRoutes.changePassword);
              },
            ),
            AppSettingsListTile(
              label: 'Изменить номер телефона',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () {
                // Navigator.pushNamed(context, AppRoutes.changePhoneNumber);
              },
            ),
            AppSettingsListTile(
              label: 'Адрес',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () {
                // Navigator.pushNamed(context, AppRoutes.deliveryAddress);
              },
            ),
            AppSettingsListTile(
              label: 'Локация',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () {},
            ),
           
            
            AppSettingsListTile(
              label: 'Удалить аккаунт',
              trailing: SvgPicture.asset(AppIcons.right),
              // onTap: () => Navigator.pushNamed(context, AppRoutes.introLogin),
            ),
          ],
        ),
      ),
    );
  }
}
