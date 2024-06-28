import 'package:bismo/core/colors.dart';
import 'package:bismo/core/presentation/components/orders_comp/app_back_button.dart';
import 'package:bismo/core/models/cart/get_notification_response.dart';
import 'package:bismo/core/services/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  final String? title;

  const NotificationView({Key? key, this.title}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  NotificationResponse? _notificationResponse;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    String phoneNumber = "7777017100"; // Укажите ваш номер телефона
    try {
      NotificationResponse? response =
          await NotificationServices().getNotifications(phoneNumber);
      setState(() {
        _notificationResponse = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Уведомления'),
      ),
      backgroundColor: AppColors.cardColor,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _notificationResponse != null &&
                  _notificationResponse!.jSONBody != null
              ? ListView.builder(
                  itemCount: _notificationResponse!.jSONBody!.length,
                  itemBuilder: (context, index) {
                    JSONBody notification =
                        _notificationResponse!.jSONBody![index];
                    return ListTile(
                      title: Text(notification.message ?? 'No message'),
                      subtitle: Text(notification.user ?? 'No user'),
                      leading: notification.photo != null
                          ? Image.network(notification.photo!)
                          : Icon(Icons.notifications),
                    );
                  },
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
