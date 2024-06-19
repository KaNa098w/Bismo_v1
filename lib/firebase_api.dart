import 'package:bismo/app/profile/notification/notification_view.dart';
import 'package:bismo/core/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications(BuildContext context) async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    print('Token:$fCMToken');

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(context, message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(context, message);
    });
  }

  void _handleMessage(BuildContext context, RemoteMessage message) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(
        '/notification',
        arguments: message,
      );
    });
  }
}

class MyApp extends StatelessWidget {
  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => HomeScreen(firebaseApi: _firebaseApi),
        '/notification': (context) => NotificationView(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final FirebaseApi firebaseApi;

  HomeScreen({required this.firebaseApi});

  @override
  Widget build(BuildContext context) {
    firebaseApi.initNotifications(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Welcome to Home Screen'),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
