import 'package:bismo/core/colors.dart';
import 'package:bismo/core/presentation/widgets/app_images.dart';
import 'package:bismo/core/presentation/widgets/auth/auth_form.dart';
import 'package:bismo/core/presentation/widgets/network_image.dart';
import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: const AspectRatio(
              aspectRatio: 1 / 1,
              child: NetworkImageWithLoader(AppImages.roundedLogo),
            ),
          ),
          Text(
            'Добро пожаловать в ',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Bismo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          const AuthForm()
        ],
      ),
    );
  }
}
