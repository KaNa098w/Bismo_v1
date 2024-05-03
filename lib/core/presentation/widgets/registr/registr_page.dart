import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/helpers/formatters.dart';
import 'package:bismo/core/helpers/validation.dart';
import 'package:bismo/core/presentation/widgets/auth/auth_form.dart';
import 'package:bismo/core/presentation/widgets/auth/custom_text_input_field.dart';
import 'package:bismo/core/presentation/widgets/registr/already_have_accout.dart';
import 'package:bismo/core/presentation/widgets/registr/sign_up_button.dart';
import 'package:bismo/core/presentation/widgets/registr/validators.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class RegistrPage extends StatefulWidget {
  const RegistrPage({
    super.key,
  });

  @override
  State<RegistrPage> createState() => _RegistrPageState();
}

class _RegistrPageState extends State<RegistrPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final otpFieldFocusNode = FocusNode();
  final bool _obscured = false;
  final AutovalidateMode _validateMode = AutovalidateMode.disabled;
  bool hidePhoneNumber = false;



  @override
  Widget build(BuildContext context) {
     return Container(
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
    );
  }
}
