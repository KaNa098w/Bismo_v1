import 'package:bismo/core/classes/route_manager.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/formatters.dart';
import 'package:bismo/core/helpers/validation.dart';
import 'package:bismo/core/models/user/SignInOtpResponse.dart';
import 'package:bismo/core/models/user/register_request.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/dialogs/loader_dialog.dart';
import 'package:bismo/core/presentation/widgets/auth/custom_text_input_field.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final otpFieldFocusNode = FocusNode();
  AutovalidateMode _validateMode = AutovalidateMode.disabled;
  bool hidePhoneNumber = false;
  SignInOtpResponse? getOtpRes;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _validateMode,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
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
          if (!hidePhoneNumber)
            const SizedBox(
              height: 11,
            ),
          if (!hidePhoneNumber)
            CustomTextInputField(
              controller: _lastnameController,
              maxLines: 1,
              containerLabelText: "Фамилия",
              hintTextStr: "Введите фамилию",
              validator: (val) {
                if (val == "") {
                  return "Обязательное поле";
                }
                return null;
              },
            ),
          if (!hidePhoneNumber)
            const SizedBox(
              height: 11,
            ),
          if (!hidePhoneNumber)
            CustomTextInputField(
              controller: _nameController,
              maxLines: 1,
              containerLabelText: "Имя",
              hintTextStr: "Введите имя",
              validator: (val) {
                if (val == "") {
                  return "Обязательное поле";
                }
                return null;
              },
            ),
          if (hidePhoneNumber)
            CustomTextInputField(
              controller: _otpController,
              maxLines: 1,
              focusNode: otpFieldFocusNode,
              containerLabelText: "Код из смс",
              hintTextStr: "Введите код из смс",
              validator: (val) {
                return null;
              },
            ),
          const SizedBox(
            height: 33,
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
                    borderRadius: BorderRadius.circular(100.0)),
              ),
              onPressed: () async {
                setState(() {
                  _validateMode = AutovalidateMode.onUserInteraction;
                });
                if (_formKey.currentState!.validate()) {
                  String phoneNumber = _phoneNumberController.text
                      .replaceAll(RegExp(r'[^0-9]'), '')
                      .substring(1);
                  String name = _nameController.text;
                  String lastname = _lastnameController.text;
                  String pass = _otpController.text;

                  var userProvider = context.read<UserProvider>();

                  if (hidePhoneNumber) {
                    // await userProvider.signIn(phoneNumber, pass, context);

                    if (getOtpRes?.smsPw != pass) {
                      if (context.mounted) {
                        showAlertDialog(
                          context: context,
                          barrierDismissible: true,
                          title: "Ошибка",
                          content: "Неправильный код",
                          actions: <Widget>[
                            CupertinoDialogAction(
                              onPressed: () => Navigator.of(context).pop(),
                              textStyle: const TextStyle(
                                  color: AppColors.primaryColor),
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      }
                    } else {
                      // await userProvider.getProfile(phoneNumber, context);
                      await userProvider.signIn(phoneNumber, pass, context);
                    }
                  } else {
                    RegisterRequest request = RegisterRequest(
                      name: name,
                      lastName: lastname,
                      login: phoneNumber,
                      nameStore: name,
                      typeStore: "1",
                    );
                    var singUpResult =
                        await userProvider.signUp(request, context);

                    if (singUpResult) {
                      SignInOtpResponse? result = await userProvider
                          .getOtpForSignIn(phoneNumber, context);

                      if (result != null) {
                        setState(() {
                          hidePhoneNumber = true;
                          getOtpRes = result;
                        });
                      }
                    }
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  "Зарегистрироваться",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
