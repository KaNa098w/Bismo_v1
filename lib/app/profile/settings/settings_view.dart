import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/helpers/login_helper.dart';
import 'package:bismo/core/presentation/components/app_settings_tile.dart';
import 'package:bismo/core/presentation/components/orders_comp/app_back_button.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  final String? title;

  const SettingsView({Key? key, this.title}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    String? category = context.watch<UserProvider>().selectedCategory;

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
              label: 'Уведомления',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
            AppSettingsListTile(
              label: 'Изменить профиль ',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () {
                Navigator.pushNamed(context, '/my_profile');
              },
            ),
            AppSettingsListTile(
              label: 'Адрес',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () {
                Navigator.pushNamed(context, '/address');
              },
            ),
            AppSettingsListTile(
              label: 'Удалить аккаунт',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () {
                Navigator.of(context).pop();
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
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
          content: const Text('Вы уверены, что хотите удалить свой аккаунт?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(BuildContext context) async {
    var response = await _userService.deleteAccount();

    if (response != null) {
      print('Account deleted successfully: ${response.toJson()}');
      // Опционально, выполнить выход из системы и перенаправить на экран входа
      Navigator.of(context).pop();
      doLogout(context);
    } else {
      // Обработка ошибки удаления аккаунта
      print('Failed to delete account.');
    }
  }
}
