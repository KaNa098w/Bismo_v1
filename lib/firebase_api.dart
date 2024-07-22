import 'package:bismo/app/profile/notification/notification_view.dart';
import 'package:bismo/core/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications(BuildContext context) async {
    // Request permission to show notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get the token for the device
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    // Handle initial message if the app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(context, message);
      }
    });

    // Handle messages when the app is in the background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(context, message);
    });

    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'launch_background',
              importance: Importance.high,
              priority: Priority.high,
              showWhen: true,
            ),
          ),
        );
      }
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
