import 'package:bismo/core/colors.dart';
import 'package:bismo/core/presentation/components/orders_comp/app_back_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    final message =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage?;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Настройки'),
      ),
      backgroundColor: AppColors.cardColor,
      body: message != null
          ? Column(
              children: [
                Text(message.notification?.body ?? 'No body'),
                Text(message.notification?.title ?? 'No title'),
                Text(message.data.toString()),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 200,
                    color: Colors.purple[200],
                  ),
                  SizedBox(height: 20.0),
                  Text('Пока что здесь пусто :)'),
                ],
              ),
            ),
    );
  }
}
