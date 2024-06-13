import 'package:bismo/core/colors.dart';
import 'package:bismo/core/presentation/components/orders_comp/app_back_button.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  final String? title;

  const NotificationView({Key? key, this.title}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 200,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 20.0),
            Text('Пока что здесь пусто :)'),
          ],
        ),
      ),
    );
  }
}
