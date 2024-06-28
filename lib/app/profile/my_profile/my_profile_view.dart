import 'package:bismo/core/colors.dart';
import 'package:bismo/core/models/user/get_my_profile_response.dart';
import 'package:bismo/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bismo/core/providers/user_provider.dart';

class MyProfileView extends StatefulWidget {
  final String phoneNumber;

  const MyProfileView(
      {Key? key, required this.phoneNumber, required String title})
      : super(key: key);

  @override
  _MyProfileViewState createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  @override
  void initState() {
    super.initState();
  }

  String formatPhoneNumber(String phoneNumber) {
    // Assuming phoneNumber is in the format '7777017100'
    if (phoneNumber.length == 10) {
      return "+7 (${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} - ${phoneNumber.substring(6, 8)} - ${phoneNumber.substring(8, 10)}";
    }
    return phoneNumber; // Return the original phone number if it doesn't match the expected format
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 65,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${userProvider.user?.storeName ?? ""}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Text(
                      formatPhoneNumber(userProvider.user?.phoneNumber ?? ""),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            // Другие данные профиля, которые вы хотите отобразить
          ],
        ),
      ),
    );
  }
}
