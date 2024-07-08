import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/app_bar_title.dart';
import 'package:bismo/core/presentation/widgets/app_images.dart';
import 'package:bismo/core/presentation/widgets/auth/auth_form.dart';
import 'package:bismo/core/presentation/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginView extends StatefulWidget {
  final String? title;
  const LoginView({Key? key, this.title}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle("Авторизация"),
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Image.asset('assets/icons/appstore.png'),
            ),
          ),
          Text(
            'Добро пожаловать ',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          const AuthForm(),
        ],
      ),
    );
  }
}
