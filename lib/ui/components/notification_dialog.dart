import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  final isIOS = !kIsWeb && Platform.isIOS;

  if (isIOS && content == null) {
    //when has a content, doesnt works well in cupertino
    await _cupertinoNotificationDialog(
      context: context,
      titleMessage: titleMessage,
      onPress: onPress,
      onCancelPress: onCancelPress,
      closeDialogOnConfirmPress: closeDialogOnConfirmPress,
      cancelMessage: cancelMessage,
      confirmMessage: confirmMessage,
      canPop: canPop,
      showCancelAndConfirmMessage: showCancelAndConfirmMessage,
      showCloseAction: showCloseAction,
    );
  } else {
    await _materialNotificationDialog(
      context: context,
      titleMessage: titleMessage,
      content: content,
      onPress: onPress,
      onCancelPress: onCancelPress,
      closeDialogOnConfirmPress: closeDialogOnConfirmPress,
      cancelMessage: cancelMessage,
      confirmMessage: confirmMessage,
      canPop: canPop,
      showCancelAndConfirmMessage: showCancelAndConfirmMessage,
      showCloseAction: showCloseAction,
    );
  }
}

Future<void> _materialNotificationDialog({
  required BuildContext context,
  required String titleMessage,
  required Widget? content,
  required Future Function() onPress,
  required Future Function()? onCancelPress,
  required bool? closeDialogOnConfirmPress,
  required String? cancelMessage,
  required String? confirmMessage,
  required bool canPop,
  required bool? showCancelAndConfirmMessage,
  required bool? showCloseAction,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        canPop: canPop,
        child: AlertDialog(
          insetPadding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 16,
          ),
          title: Text(
            titleMessage,
            style: TextStyle(
              fontSize: ScreenSize.hasMinWidth ? 30 : 23,
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
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
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
                child: Text(R.string.close),
              ),
          ],
        ),
      );
    },
  );
}

Future<void> _cupertinoNotificationDialog({
  required BuildContext context,
  required String titleMessage,
  required Future Function() onPress,
  required Future Function()? onCancelPress,
  required bool? closeDialogOnConfirmPress,
  required String? cancelMessage,
  required String? confirmMessage,
  required bool canPop,
  required bool? showCancelAndConfirmMessage,
  required bool? showCloseAction,
}) async {
  await showCupertinoDialog(
    context: context,
    barrierDismissible: canPop,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          titleMessage,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          if (showCancelAndConfirmMessage == true)
            CupertinoDialogAction(
              onPressed: () async {
                if (onCancelPress != null) await onCancelPress();
                Navigator.of(context).pop();
              },
              isDestructiveAction: true,
              child: Text(cancelMessage ?? R.string.no),
            ),
          if (showCancelAndConfirmMessage == true)
            CupertinoDialogAction(
              onPressed: () async {
                if (closeDialogOnConfirmPress == true) {
                  Navigator.of(context).pop();
                }
                await onPress();
              },
              isDefaultAction: true,
              child: Text(confirmMessage ?? R.string.yes),
            ),
          if (showCloseAction == true)
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(R.string.close),
            ),
        ],
      );
    },
  );
}
