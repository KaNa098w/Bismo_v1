import 'package:bismo/app/root.dart';
import 'package:bismo/core/classes/route_manager.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/formatters.dart';
import 'package:bismo/core/helpers/validation.dart';
import 'package:bismo/core/models/user/SignInOtpResponse.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/widgets/auth/custom_text_input_field.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:platform/platform.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final otpFieldFocusNode = FocusNode();
  AutovalidateMode _validateMode = AutovalidateMode.disabled;
  bool hidePhoneNumber = false;
  bool canResendOtp = true;
  int _counter = 0;
  Timer? _timer;
  SingInOtpResponse? getOtpRes;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startOtpTimer() {
    setState(() {
      _counter = 30;
      canResendOtp = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          canResendOtp = true;
          timer.cancel();
        }
      });
    });
  }

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
          if (hidePhoneNumber)
            Text(
              'SMS отправлено на номер: ${_phoneNumberController.text}',
              style: TextStyle(color: Colors.grey),
            ),
          SizedBox(
            height: 12,
          ),
          if (hidePhoneNumber)
            Column(
              children: [
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
                TextButton(
                  onPressed: () {
                    setState(() {
                      hidePhoneNumber = false;
                      _otpController.clear();
                    });
                  },
                  child: const Text(
                    'Изменить номер телефона',
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
                if (!canResendOtp)
                  Text(
                    'Повторная отправка через $_counter секунд',
                    style: const TextStyle(color: Colors.grey),
                  ),
                if (canResendOtp)
                  TextButton(
                    onPressed: () async {
                      String phoneNumber = _phoneNumberController.text
                          .replaceAll(RegExp(r'[^0-9]'), '')
                          .substring(1);

                      var userProvider = context.read<UserProvider>();
                      SingInOtpResponse? result = await userProvider
                          .getOtpForSignIn(phoneNumber, context);

                      if (result != null) {
                        setState(() {
                          getOtpRes = result;
                          _startOtpTimer(); // Start the OTP timer
                        });
                      }
                    },
                    child: const Text(
                      'Отправить смс повторно',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
              ],
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
                  String pass = _otpController.text;

                  var userProvider = context.read<UserProvider>();

                  // Test condition for bypassing OTP verification
                  if (phoneNumber == "9999999999" && pass == "1234") {
                    await userProvider.signIn(phoneNumber, pass, context);
                    await _handlePostRegistrationLogic(phoneNumber);
                  } else if (hidePhoneNumber) {
                    // Check for the specific OTP "1234" to bypass the SMS validation only for the specific phone number
                    if (phoneNumber == "9999999999" && pass == "1234" ||
                        getOtpRes?.smsPw == pass) {
                      await userProvider.signIn(phoneNumber, pass, context);
                      await _handlePostRegistrationLogic(phoneNumber);
                    } else {
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
                    }
                  } else {
                    // Skip SMS sending for the specific phone number
                    if (phoneNumber == "9999999999") {
                      setState(() {
                        hidePhoneNumber = true;
                        _startOtpTimer(); // Start the OTP timer
                      });
                    } else {
                      SingInOtpResponse? result = await userProvider
                          .getOtpForSignIn(phoneNumber, context);

                      if (result != null) {
                        setState(() {
                          hidePhoneNumber = true;
                          getOtpRes = result;
                          _startOtpTimer(); // Start the OTP timer
                        });
                      }
                    }
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  "Войти",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
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
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0)),
              ),
              onPressed: () {
                Nav.toNamed(context, "/register");
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
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0)),
              ),
              onPressed: () async {
                // Пропустить регистрацию, передать пустой номер телефона
                await _handlePostRegistrationLogic("");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Root()), // Замените Root на ваш виджет после успешной регистрации
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  "Пропустить регистрацию",
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

  Future<void> _handlePostRegistrationLogic(String phoneNumber) async {
    var userProvider = context.read<UserProvider>();

    if (phoneNumber.isNotEmpty) {
      await userProvider.signIn(phoneNumber, "1234", context);
    }

    await _sendPostRequest(phoneNumber);

    // Любые дополнительные действия после успешной регистрации или пропуска регистрации
  }

  Future<void> _sendPostRequest(String phoneNumber) async {
    final fCMToken = await FirebaseMessaging.instance.getToken();
    final platform = LocalPlatform();
    String deviceType = platform.isAndroid
        ? 'Android'
        : platform.isIOS
            ? 'iOS'
            : 'Unknown';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic d2ViOjc3NTc0OTk0NTFkbA=='
    };
    var data = {
      "login": phoneNumber.isNotEmpty ? phoneNumber : "skipped",
      "device_token": fCMToken,
      "device_type": deviceType,
      "type": "post"
    };

    var dio = Dio();
    var response = await dio.post(
      'http://188.95.95.122:2223/server/hs/all/settoken',
      options: Options(
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print(response.data);
    } else {
      print(response.statusMessage);
    }
  }
}
