import 'dart:convert';

import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/presentation/widgets/registr/already_have_accout.dart';
import 'package:bismo/core/presentation/widgets/registr/sign_up_button.dart';
import 'package:bismo/core/presentation/widgets/registr/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class RegistView extends StatefulWidget {
  final String? title;
  const RegistView({Key? key, this.title}) : super(key: key);

  @override
  State<RegistView> createState() => _RegistViewState();
}

class _RegistViewState extends State<RegistView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController loginController = TextEditingController();
  TextEditingController nameStoreController = TextEditingController();

  Future<void> _register() async {
    var url = Uri.parse('YOUR_API_ENDPOINT_HERE');

    var response = await http.post(url, body: {
      "name": nameController.text,
      "last_name": lastNameController.text,
      "login": loginController.text,
      "name_store": nameStoreController.text,
      "type_store": "1",
      "categories": jsonEncode([
        {"id": "000000002"}
      ]),
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
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
              controller: nameController,
              validator: Validators.requiredWithFieldName('Имя'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 8),
            const Text("Фамилия"),
            const SizedBox(height: 8),
            TextFormField(
              controller: lastNameController,
              textInputAction: TextInputAction.next,
              validator: Validators.requiredWithFieldName('Фамилия'),
            ),
            const SizedBox(height: 8),
            const Text("Номер телефона"),
            const SizedBox(height: 8),
            TextFormField(
              controller: loginController,
              textInputAction: TextInputAction.next,
              validator: Validators.requiredWithFieldName('Номер телефона'),
            ),
            const SizedBox(height: 8),
            const Text("Код из СМС"),
            const SizedBox(height: 8),
            TextFormField(
              controller: nameStoreController,
              textInputAction: TextInputAction.next,
              validator: Validators.requiredWithFieldName('Код из СМС'),
            ),
            const SizedBox(height: 8),
            const Text("Название Магазина"),
            const SizedBox(height: 8),
            TextFormField(
              validator: Validators.required,
              textInputAction: TextInputAction.next,
              obscureText: true,
              decoration: const InputDecoration(
                
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Зарегистрироваться'),
            ),
            const AlreadyHaveAnAccount(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
