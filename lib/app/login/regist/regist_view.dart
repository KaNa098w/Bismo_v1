import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/presentation/widgets/registr/already_have_accout.dart';
import 'package:bismo/core/presentation/widgets/registr/sign_up_button.dart';
import 'package:bismo/core/presentation/widgets/registr/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class RegistView extends StatefulWidget {
  final String? title;
  const RegistView({Key? key, this.title}) : super(key: key);

  @override
  State<RegistView> createState() => _RegistViewState();
}

class _RegistViewState extends State<RegistView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
      return Scaffold(
 
  body: Container(
    margin: const EdgeInsets.all(AppDefaults.margin),
    padding: const EdgeInsets.all(AppDefaults.padding),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: AppDefaults.boxShadow,
      borderRadius: AppDefaults.borderRadius,
    ), 
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Имя"),
        const SizedBox(height: 8),
        TextFormField(
          validator: Validators.requiredWithFieldName('Имя'),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppDefaults.padding),
        const Text("Номер телефона:"),
        const SizedBox(height: 8),
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: Validators.required,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: AppDefaults.padding),
        const Text("Password"),
        const SizedBox(height: 8),
        TextFormField(
          validator: Validators.required,
          textInputAction: TextInputAction.next,
          obscureText: true,
          decoration: InputDecoration(
            suffixIcon: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  AppIcons.eye,
                  width: 24,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDefaults.padding),
        const SignUpButton(),
        const AlreadyHaveAnAccount(),
        const SizedBox(height: AppDefaults.padding),
      ],
    ),
  ),
);

    
  }
}
