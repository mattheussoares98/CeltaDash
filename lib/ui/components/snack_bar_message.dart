import 'package:flutter/material.dart';

import '../../main/utils/utils.dart';
import '../helpers/helpers.dart';

void snackBarMessage(
  BuildContext context,
  String message,
  Color backgroundColor,
) {
  ScaffoldMessenger.of(NavigatorKey.key.currentContext ?? context)
      .clearSnackBars();
  ScaffoldMessenger.of(NavigatorKey.key.currentContext ?? context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize:
              hasMinWidth(NavigatorKey.key.currentContext ?? context) ? 25 : 17,
        ),
      ),
      dismissDirection: DismissDirection.down,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      showCloseIcon: true,
      closeIconColor: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
