import 'package:bismo/core/colors.dart';
import 'package:bismo/core/helpers/formatters.dart';
import 'package:bismo/core/helpers/validation.dart';
import 'package:bismo/core/models/user/SignInOtpResponse.dart';
import 'package:bismo/core/models/user/get_category_user_response.dart';
import 'package:bismo/core/models/user/get_profile_response.dart';
import 'package:bismo/core/models/user/register_request.dart';
import 'package:bismo/core/presentation/dialogs/cupertino_dialog.dart';
import 'package:bismo/core/presentation/widgets/auth/custom_text_input_field.dart';
import 'package:bismo/core/providers/user_provider.dart';
import 'package:bismo/core/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:bismo/core/models/user/get_my_profile_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bismo/core/providers/user_provider.dart';

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
  final TextEditingController _categoryController = TextEditingController();
  final otpFieldFocusNode = FocusNode();
  AutovalidateMode _validateMode = AutovalidateMode.disabled;
  bool hidePhoneNumber = false;
  SingInOtpResponse? getOtpRes;
  List<UserCategories>? _categories;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
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
                  height: 11,
                ),
                GestureDetector(
                  onTap: () => _showCategorySelectionDialog(context),
                  child: AbsorbPointer(
                    child: CustomTextInputField(
                      controller: _categoryController,
                      maxLines: 1,
                      containerLabelText: "Категория",
                      hintTextStr: "Выберите категорию",
                      validator: (val) {
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
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
                            if (getOtpRes?.smsPw != pass) {
                              if (context.mounted) {
                                showAlertDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  title: "Ошибка",
                                  content: "Неправильный код",
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      textStyle: const TextStyle(
                                          color: AppColors.primaryColor),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              }
                            } else {
                              await userProvider.signIn(
                                  phoneNumber, pass, context);
                              var profile = GetMyProfileResponse(
                                name: name,
                                lastname: lastname,
                                login: phoneNumber,
                              );
                              userProvider.setProfile(profile);
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
                              SingInOtpResponse? result = await userProvider
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
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCategorySelectionDialog(BuildContext context) async {
    final categories =
        await UserService().getUserCategory(_phoneNumberController.text);
    setState(() {
      _categories = categories?.categories;
    });

    if (_categories == null || _categories!.isEmpty) {
      showAlertDialog(
        context: context,
        barrierDismissible: true,
        title: "Ошибка",
        content: "Не удалось загрузить категории",
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            textStyle: const TextStyle(color: AppColors.primaryColor),
            child: const Text("OK"),
          ),
        ],
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Выберите категорию",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _categories!.length,
              itemBuilder: (BuildContext context, int index) {
                final category = _categories![index];
                return ListTile(
                  title: Text(category.name ?? ""),
                  onTap: () {
                    setState(() {
                      _categoryController.text = category.name!;
                      context.read<UserProvider>().setSelectedCategory(
                          category.name); // Сохраняем категорию в провайдере
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
