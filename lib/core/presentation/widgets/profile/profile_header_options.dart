import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/presentation/widgets/profile/profile_squre_tile.dart';
import 'package:flutter/material.dart';


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
              // Navigator.pushNamed(context, AppRoutes.myOrder);
            },
          ),
         
          ProfileSqureTile(
            label: 'Адрес',
            icon: AppIcons.homeProfile,
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.deliveryAddress);
            },
            
          ),
           ProfileSqureTile(
            label: 'Поддержка',
            icon: AppIcons.support, 
            onTap: () {
              // Navigator.pushNamed(context, AppRoutes.coupon);
            },
          ),
        ],
      ),
    );
  }
}
