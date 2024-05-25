import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/presentation/components/app_settings_tile.dart';
import 'package:bismo/core/presentation/components/orders_comp/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SupportView extends StatefulWidget {
  final String? title;

  const SupportView({Key? key, this.title}) : super(key: key);

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Профиль',
        ),
      ),
      backgroundColor: AppColors.cardColor,
      body: const Center(
        child: 
        
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle_outlined, size: 200, color: Colors.black45,),
            SizedBox(height: 20.0),
            Text('Пока что здесь пусто :)'),
          ],
        ),
        
          
        ),
      
    );
  }
}
