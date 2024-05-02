import 'package:flutter/cupertino.dart';

showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  List<Widget>? actions,
  bool? barrierDismissible,
}) async {
  await showCupertinoDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible ?? false,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions ?? [const SizedBox()],
    ),
  );
}
