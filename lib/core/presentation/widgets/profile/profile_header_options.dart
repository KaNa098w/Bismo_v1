import 'dart:io';

import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/presentation/widgets/profile/profile_squre_tile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileHeaderOptions extends StatelessWidget {
  const ProfileHeaderOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.padding),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDefaults.borderRadius,
        boxShadow: AppDefaults.boxShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileSqureTile(
            label: 'Мои заказы',
            icon: AppIcons.truckIcon,
            onTap: () {
              Navigator.pushNamed(context, '/orders');
            },
          ),
          ProfileSqureTile(
            label: 'Адрес',
            icon: AppIcons.homeProfile,
            onTap: () {
              Navigator.pushNamed(context, '/address');
            },
          ),
          ProfileSqureTile(
            label: 'Поддержка',
            icon: AppIcons.support,
            onTap: () async {
              // const phoneNumber = '77077303923';
              // const whatsappUrl = "whatsapp://send?phone=$phoneNumber";
              // if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
              //   await launchUrl(Uri.parse(whatsappUrl));
              // } else {
              //   throw 'Could not launch $whatsappUrl';
              // }

              String contact = "77077303923";
              String text = '';
              String androidUrl = "whatsapp://send?phone=$contact&text=$text";
              String iosUrl = "https://wa.me/$contact?text=${Uri.parse(text)}";

              String webUrl =
                  'https://api.whatsapp.com/send/?phone=$contact&text=hi';

              try {
                if (Platform.isIOS) {
                  if (await canLaunchUrl(Uri.parse(iosUrl))) {
                    await launchUrl(Uri.parse(iosUrl));
                  }
                } else {
                  if (await canLaunchUrl(Uri.parse(androidUrl))) {
                    await launchUrl(Uri.parse(androidUrl));
                  }
                }
              } catch (e) {
                print('object');
                await launchUrl(Uri.parse(webUrl),
                    mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
    );
  }
}
