import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/presentation/widgets/ad_space.dart';
import 'package:bismo/core/presentation/widgets/our_new_item.dart';
import 'package:bismo/core/presentation/widgets/popular_packs.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  final String? title;
  const SettingsView({Key? key, this.title}) : super(key: key);
  
  

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
   return Container(
      color: Colors.transparent,
      child: InkWell(
      
        borderRadius: AppDefaults.borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                   'KALAI',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                        ),
                  ),
              //     const Spacer(),
              //     if (trailing != null) trailing!,
                 ],
               ),
              // const Divider(thickness: 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
