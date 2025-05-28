import 'package:flutter/material.dart';

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
        style: Theme.of(context).textTheme.titleSmall,
      ),
      dismissDirection: DismissDirection.down,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).disabledColor,
        ),
      ),
      showCloseIcon: true,
      closeIconColor: Theme.of(context).textTheme.titleSmall?.color,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
