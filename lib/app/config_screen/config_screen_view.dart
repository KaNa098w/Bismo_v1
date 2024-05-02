import 'package:bismo/app/config_screen/config_screen_controller.dart';
import 'package:bismo/app/login/login_controller.dart';
import 'package:bismo/app/root.dart';
import 'package:bismo/core/app_cache.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/providers/global_state_manager.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigScreenView extends StatefulWidget {
  final String? title;
  const ConfigScreenView({Key? key, this.title}) : super(key: key);

  @override
  State<ConfigScreenView> createState() => _ConfigScreenViewState();
}

class _ConfigScreenViewState extends State<ConfigScreenView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var userProvider = context.read<UserProvider>();
      var cache = AppCache();
      var isLoginResult = await cache.isLogin();
      setState(() {
        userProvider.setIsLogin(isLoginResult);
        userProvider.setLoading(false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();
    return Consumer<GlobalStateManager>(
      builder: (context, configProvider, _) {
        if (userProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: Center(
                    child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                )),
              ),
            ),
          );
        }
        if (!userProvider.isLogin) {
          return const LoginController();
        }
        return const Root();
      },
    );
  }
}
