import 'package:flutter/material.dart';

import '../../ui/helpers/helpers.dart';

void showErrorMessage(BuildContext context, String error,
    {Duration? duration = const Duration(seconds: 4)}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration!,
      backgroundColor: Colors.red[900],
      content: Text(
        error,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: hasMinWidth(context) ? 17 : 13,
        ),
      ),
      dismissDirection: DismissDirection.down,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      showCloseIcon: true,
      closeIconColor: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
