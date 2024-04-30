import 'package:bismo/app/root.dart';
import 'package:bismo/core/colors.dart';
import 'package:bismo/core/providers/global_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigScreenView extends StatefulWidget {
  final String? title;
  const ConfigScreenView({Key? key, this.title}) : super(key: key);

  @override
  State<ConfigScreenView> createState() => _ConfigScreenViewState();
}

class _ConfigScreenViewState extends State<ConfigScreenView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStateManager>(
      builder: (context, configProvider, _) {
        return const Root();
      },
    );
  }
}
