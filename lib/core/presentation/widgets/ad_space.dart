import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/presentation/widgets/network_image.dart';
import 'package:flutter/material.dart';

class AdSpace extends StatelessWidget {
  const AdSpace({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const AspectRatio(
          aspectRatio: 16 / 9,
          child: NetworkImageWithLoader(
            'https://i.imgur.com/8hBIsS5.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
