import 'package:bismo/app/config_screen/config_screen_view.dart';
import 'package:bismo/core/app_routes.dart';
import 'package:bismo/core/presentation/theme.dart';
import 'package:bismo/core/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final providers = await getAppProviders();

  runApp(MultiProvider(
    providers: providers,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
