import 'package:bismo/app/login/regist/regist_controller.dart';
import 'package:bismo/core/classes/route_manager.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/formatters.dart';
import 'package:bismo/core/helpers/validation.dart';
import 'package:bismo/core/presentation/widgets/auth/custom_text_input_field.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegistrForm extends StatefulWidget {
  const RegistrForm({
    super.key,
  });

  @override
  State<RegistrForm> createState() => _RegistrFormState();
}

class _RegistrFormState extends State<RegistrForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final otpFieldFocusNode = FocusNode();
  bool _obscured = false;
  final AutovalidateMode _validateMode = AutovalidateMode.disabled;
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
                // Navigator.pushNamed(context, "/register");

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
        ],
      ),
    );
  }
}
