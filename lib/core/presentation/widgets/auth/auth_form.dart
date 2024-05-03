import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/formatters.dart';
import 'package:bismo/core/helpers/validation.dart';
import 'package:bismo/core/presentation/widgets/auth/custom_text_input_field.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  bool _obscured = false;
  AutovalidateMode _validateMode = AutovalidateMode.disabled;
  bool hidePhoneNumber = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (otpFieldFocusNode.hasPrimaryFocus) {
        return;
      }
      otpFieldFocusNode.canRequestFocus = false;
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
              // suffixIcon: Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
              //   child: GestureDetector(
              //     onTap: _toggleObscured,
              //     child: Icon(
              //       !_obscured
              //           ? Icons.visibility_rounded
              //           : Icons.visibility_off_rounded,
              //       size: 24,
              //       color: const Color(0x702b2b2b),
              //     ),
              //   ),
              // )
            ),
          const SizedBox(
            height: 10,
          ),
          // GestureDetector(
          //   onTap: () {
          //     Nav.toNamed(context, "/reset_password");
          //   },
          //   child: Container(
          //     padding: const EdgeInsets.only(right: 30),
          //     alignment: Alignment.topRight,
          //     child: Text(
          //       AppLocalizations.of(context)!.lostPassword,
          //       style: const TextStyle(
          //           color: Color(0xFF707B81),
          //           fontSize: 12,
          //           fontWeight: FontWeight.w400),
          //     ),
          //   ),
          // ),
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
                  String pass = _otpController.text;

                  var userProvider = context.read<UserProvider>();

                  if (hidePhoneNumber) {
                    await userProvider.signIn(phoneNumber, pass, context);
                  } else {
                    var boolRes = await userProvider.getOtpForSignIn(
                        phoneNumber, context);

                    if (boolRes) {
                      setState(() {
                        hidePhoneNumber = true;
                      });
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
          //  const SizedBox(
          //   height: 33),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 30),
          //   width: double.infinity,
          //   height: 43,
          //   child: OutlinedButton(
          //     style: OutlinedButton.styleFrom(
          //       side: const BorderSide(
          //         color: Colors.transparent,
          //       ),
          //       backgroundColor: Colors.white,
          //       foregroundColor: Colors.black,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(100.0)),
          //     ),
          //     onPressed: ()  {
          //       Navigator.push(
          //         context,
                
          //       );
          //     },
          //     child: Container(
          //       alignment: Alignment.center,
          //       child: const Text(
          //         "Зарегистрироваться",
          //         textAlign: TextAlign.center,
          //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //       ),
          //     ),
          //   ),
          // ),   
        ],
      ),
    );
  }
}
