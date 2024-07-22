import 'package:bismo/core/classes/route_manager.dart';
import 'package:flutter/material.dart';

Widget appBarBack(BuildContext context,
    {Color color = Colors.black, dynamic popData}) {
  return IconButton(
    onPressed: () {
      // Navigator.of(context).pop();
      Nav.close(context, popData);
    },
    icon: Icon(
      Icons.arrow_back_outlined,
      color: color,
    ),
  );
}
