import 'package:bismo/core/colors.dart';
import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/constants/app_icons.dart';
import 'package:bismo/core/presentation/components/app_radio.dart';
import 'package:bismo/core/presentation/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddressView extends StatefulWidget {
  final String? title;
  const AddressView({Key? key, this.title}) : super(key: key);

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Адрес',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(AppDefaults.margin),
        padding: const EdgeInsets.all(AppDefaults.padding),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: AppDefaults.borderRadius,
        ),
        child: Stack(
          children: [
            ListView.separated(
              itemBuilder: (context, index) {
                return AddressTile(
                  label: 'Шымкент, мкр Нурсат',
                  address: 'дом 129 кв 63',
                  number: '+7777 701 7100',
                  isActive: index == 0,
                );
              },
              itemCount: 2,
              separatorBuilder: (context, index) =>
                  const Divider(thickness: 0.2),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/location');
                },
                backgroundColor: AppColors.primary,
                splashColor: AppColors.primary,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );

}
}
class AddressTile extends StatelessWidget {
  const AddressTile({
    Key? key,
    required this.address,
    required this.label,
    required this.number,
    required this.isActive,
  }) : super(key: key);
 final String address;
  final String label;
  final String number;
  final bool isActive;

   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppRadio(isActive: isActive),
          const SizedBox(width: AppDefaults.padding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                    ),
              ),
              const SizedBox(height: 4),
              Text(address),
              const SizedBox(height: 4),
              Text(
                number,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                    ),
              )
            ],
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(AppIcons.edit),
                constraints: const BoxConstraints(),
                iconSize: 14,
              ),
              const SizedBox(height: AppDefaults.margin / 2),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(AppIcons.deleteOutline),
                constraints: const BoxConstraints(),
                iconSize: 14,
              ),
            ],
          )
        ],
      ),
    );
  }
}