import 'package:bismo/app/config_screen/config_screen_view.dart';
import 'package:bismo/core/app_routes.dart';
import 'package:bismo/core/presentation/theme.dart';
import 'package:bismo/core/providers/app_providers.dart';
import 'package:bismo/firebase_api.dart';
import 'package:bismo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final providers = await getAppProviders();

  PersistentShoppingCart().init();
  initializeDateFormatting();

  runApp(MultiProvider(
    providers: providers,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseApi().initNotifications(context);
    return MaterialApp(
      title: 'Bismo',
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routes: Routes().routes,
      home: const ConfigScreenView(),
    );
  }
}
