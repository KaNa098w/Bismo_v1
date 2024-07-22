import 'package:flutter/material.dart';


class AlreadyHaveAnAccount extends StatelessWidget {
  const AlreadyHaveAnAccount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('У вас есть аккаунт?'),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          child: const Text('Войти'),
        ),
      ],
    );
  }
}
