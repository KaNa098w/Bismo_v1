import 'package:bismo/core/classes/display_manager.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
abstract class StatelessController extends StatelessWidget {
  const StatelessController({Key? key}) : super(key: key);

  bool get auth => false;

  String get loginUrl => "/login";

  Display view(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return view(context);
  }
}

// ignore: must_be_immutable
abstract class StatefulController extends StatefulWidget {
  const StatefulController({Key? key}) : super(key: key);
}

abstract class ControllerState<T extends StatefulController> extends State<T> {
  bool get auth => false;

  String get loginUrl => "/login";

  Display view(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return view(context);
  }
}
