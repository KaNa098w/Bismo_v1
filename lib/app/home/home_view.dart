import 'package:bismo/core/constants/app_defaults.dart';
import 'package:bismo/core/presentation/widgets/ad_space.dart';
import 'package:bismo/core/presentation/widgets/our_new_item.dart';
import 'package:bismo/core/presentation/widgets/popular_packs.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  final String? title;
  const HomeView({Key? key, this.title}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return   SafeArea(
      child: CustomScrollView(
        slivers: [
          
          SliverToBoxAdapter(
           child: AdSpace(),
          ),
        
          
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: AppDefaults.padding),
            sliver: SliverToBoxAdapter(
              child: OurNewItem(),
            ),
          ),
        ],
      ),
    );
  }
}
