import 'package:flutter/material.dart';


class AlreadyHaveAnAccount extends StatelessWidget {
  const AlreadyHaveAnAccount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already Have Account?'),
        // TextButton(
        //   // onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
        //   // child: const Text('Log In'),
        // ),
      ],
    );
  }
}
