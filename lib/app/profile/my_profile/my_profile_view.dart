import 'package:bismo/core/models/user/get_profile_response.dart';
import 'package:bismo/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProfileView extends StatefulWidget {
  final String phoneNumber;

  const MyProfileView({Key? key, required this.phoneNumber, required String title}) : super(key: key);

  @override
  _MyProfileViewState createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder<GetProfileResponse?>(
      future: authService.getProfile(widget.phoneNumber), // Передаем номер телефона
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Ошибка: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final profile = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Профиль'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Имя: ${profile.name}'),
                  Text('Фамилия: ${profile.lastname}'),
                  Text('Номер клиента: ${profile.login}'),
                  // Другие данные профиля, которые вы хотите отобразить
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Профиль не найден'),
          );
        }
      },
    );
  }
}
