import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/app_bar_back.dart';
import 'package:bismo/core/helpers/app_bar_title.dart';
import 'package:bismo/core/presentation/widgets/app_images.dart';
import 'package:bismo/core/presentation/widgets/network_image.dart';
import 'package:bismo/core/presentation/widgets/registr/register_form.dart';
import 'package:flutter/material.dart';

class RegistView extends StatefulWidget {
  final String? title;
  const RegistView({Key? key, this.title}) : super(key: key);

  @override
  State<RegistView> createState() => _RegistViewState();
}

class _RegistViewState extends State<RegistView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle("Регистрация"),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: appBarBack(context),
      ),
      body: const Column(
        children: [
          RegisterForm(),
        ],
      ),
    );
  }
}
