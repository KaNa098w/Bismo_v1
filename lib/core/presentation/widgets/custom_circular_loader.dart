import 'package:bismo/core/colors.dart';
import 'package:flutter/material.dart';

class CustomCircularLoader extends StatelessWidget {
  const CustomCircularLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.0,
            width: 50.0,
            child: Center(
                child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            )),
          ),
        ],
      ),
    );
  }
}
