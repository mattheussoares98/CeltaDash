import 'package:flutter/material.dart';

import '../../ui/helpers/helpers.dart';

Future<void> notificationDialog({
  required BuildContext context,
  required String titleMessage,
  required Widget? content,
  required Future Function() onPress,
  Future Function()? onCancelPress,
  bool? closeDialogOnConfirmPress = true,
  String? cancelMessage,
  String? confirmMessage,
  bool canPop = true,
  bool? showCancelAndConfirmMessage = true,
  bool? showLargeDialog = true,
  bool? showCloseAction = false,
}) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: canPop,
          child: AlertDialog(
            insetPadding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            title: Text(
              titleMessage,
              style: TextStyle(
                fontSize: hasMinWidth(context) ? 30 : 23,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: content,
            actions: [
              if (showCancelAndConfirmMessage == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          if (onCancelPress != null) {
                            await onCancelPress();
                          }
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          cancelMessage ?? R.string.no,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          if (closeDialogOnConfirmPress == true) {
                            Navigator.of(context).pop();
                          }
                          await onPress();
                        },
                        child: FittedBox(
                          child: Text(
                            confirmMessage ?? R.string.yes,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (showCloseAction == true)
                TextButton(
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    R.string.close,
                  ),
                ),
            ],
          ),
        );
      });
}
