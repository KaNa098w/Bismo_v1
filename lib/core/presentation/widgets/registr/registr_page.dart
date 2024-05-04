import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/helpers/formatters.dart';
import 'package:bismo/core/helpers/validation.dart';
import 'package:bismo/core/presentation/widgets/auth/custom_text_input_field.dart';
import 'package:bismo/core/presentation/widgets/registr/already_have_accout.dart';
import 'package:bismo/core/presentation/widgets/registr/sign_up_button.dart';
import 'package:bismo/core/presentation/widgets/registr/validators.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RegistrPage extends StatefulWidget {
  const RegistrPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegistrPage> createState() => _RegistrPageState();
}

class _RegistrPageState extends State<RegistrPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final otpFieldFocusNode = FocusNode();
  final bool _obscured = false;
  AutovalidateMode _validateMode = AutovalidateMode.disabled;
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
      child: Form(
        key: _formKey,
        autovalidateMode: _validateMode,
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
            if (!hidePhoneNumber)
              CustomTextInputField(
                controller: _phoneNumberController,
                maxLines: 1,
                containerLabelText: "Номер телефона",
                hintTextStr: "+7 (777) 777-77-77",
                inputFormatter: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneNumberTextInputFormatter()
                ],
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (!isPhoneNumberValid(val)) {
                    return "Неправильный формат номера";
                  }
                  return null;
                },
              ),
            if (hidePhoneNumber)
              CustomTextInputField(
                controller: _otpController,
                maxLines: 1,
                obscureText: _obscured,
                focusNode: otpFieldFocusNode,
                containerLabelText: "Код из смс",
                hintTextStr: "Введите код из смс",
                validator: (val) {
                  return null;
                },
              ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              height: 43,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _validateMode = AutovalidateMode.onUserInteraction;
                  });
                  if (_formKey.currentState!.validate()) {
                    String phoneNumber = _phoneNumberController.text.replaceAll(RegExp(r'[^0-9]'), '').substring(1);
                    String pass = _otpController.text;

                    var userProvider = context.read<UserProvider>();

                    if (hidePhoneNumber) {
                      await userProvider.signIn(phoneNumber, pass, context);
                    } else {
                      var boolRes = await userProvider.getOtpForSignIn(phoneNumber, context);

                      if (boolRes) {
                        setState(() {
                          hidePhoneNumber = true;
                        });
                      }
                    }
                  }
                },
                child: const Text("Button"),
              ),
            ),
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
