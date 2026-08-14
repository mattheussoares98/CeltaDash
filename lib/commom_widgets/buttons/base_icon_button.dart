import 'dart:async';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseIconButton extends StatelessWidget {
  const BaseIconButton({
    super.key,
    required this.onPressed,
    required this.platformIcon,
    this.padding,
    this.targetSize,
    this.excludeFromFocus = false,
    this.isLoading = false,
  });
  final FutureOr<void>? Function()? onPressed;
  final PlatformIcon platformIcon;
  final EdgeInsets? padding;
  final double? targetSize;
  final bool excludeFromFocus;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    FutureOr<void>? tapCallback() async {
      FocusManager.instance.primaryFocus?.unfocus();
      return onPressed?.call();
    }

    final iconWidget = platformIcon.copyWith(
      color: onPressed == null ? context.theme.disabledColor : null,
    );

    Widget child;

    if (context.isCupertino) {
      child = CupertinoButton(
        onPressed: isLoading || onPressed == null ? null : tapCallback,
        padding: padding ?? EdgeInsets.zero,
        child: iconWidget,
      );
    } else {
      child = IconButton(
        onPressed: isLoading || onPressed == null ? null : tapCallback,
        icon: iconWidget,
        padding: padding ?? EdgeInsets.zero,
      );
    }

    if (targetSize != null) {
      child = SizedBox(height: targetSize, width: targetSize, child: child);
    }

    if (excludeFromFocus) {
      child = ExcludeFocus(child: child);
    }

    return child;
  }
}
