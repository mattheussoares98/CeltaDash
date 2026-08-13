import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

// Kept for backward compatibility — no longer used internally.
// If any call site still references scaffoldMessengerKey for the
// ScaffoldMessenger, it can safely be removed later.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

enum ToastType { error, success }

void showToastMessage(
  String message, {
  ToastType type = ToastType.success,
  Duration? duration,
}) {
  toastification.dismissAll();
  toastification.show(
    title: BaseText.title(message, textAlign: TextAlign.center),
    alignment: Alignment.bottomCenter,
    autoCloseDuration: duration ?? const Duration(seconds: 4),
    primaryColor: Colors.white,
    backgroundColor: type == ToastType.success ? Colors.green : Colors.red,
    foregroundColor: Colors.white,
    borderRadius: BorderRadius.circular(8),
    showProgressBar: true,
    pauseOnHover: false,
    closeOnClick: true,
    dragToClose: true,
    showIcon: false,
    dismissDirection: DismissDirection.vertical,
    style: ToastificationStyle.flat,
    closeButton: ToastCloseButton(
      buttonBuilder: (context, onClose) {
        return IconButton(
          icon: type == ToastType.success
              ? const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.check_mark,
                  materialIcon: Icons.check,
                  size: 16,
                )
              : const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.xmark,
                  materialIcon: Icons.close,
                  size: 16,
                ),
          color: Colors.white,
          onPressed: onClose,
        );
      },
    ),
    type: type == ToastType.success
        ? ToastificationType.success
        : ToastificationType.error,
    applyBlurEffect: false,
  );
}
