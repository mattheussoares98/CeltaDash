import 'dart:async';

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onTap,
    required this.text,
    this.textType = TextType.bodyLarge,
    this.textFontWeight = FontWeight.w500,
    this.foregroundColor,
    this.height,
    this.width,
    this.color,
    this.elevation,
    this.expandWidth = false,
    this.platformIcon,
    this.isLoading = false,
  });
  final FutureOr<void> Function()? onTap;
  final String text;
  final TextType textType;
  final FontWeight textFontWeight;
  final Color? foregroundColor;
  final double? height;
  final double? width;
  final Color? color;
  final double? elevation;
  final bool expandWidth;
  final bool isLoading;
  final PlatformIcon? platformIcon;

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? context.colorScheme.primary;
    final activeForegroundColor =
        color ?? foregroundColor ?? context.colorScheme.primary;

    final tapCallback = onTap == null
        ? null
        : () {
            FocusManager.instance.primaryFocus?.unfocus();
            onTap!();
          };

    final childWidget = isLoading
        ? LoadingCircle.small(activeForegroundColor)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (platformIcon != null) ...[
                Flexible(flex: (text.length / 3).ceil(), child: platformIcon!),
                gapW8,
              ],
              Flexible(
                flex: text.length,
                child: BaseText(
                  text,
                  color: activeForegroundColor,
                  textType: textType,
                  fontWeight: textFontWeight,
                ),
              ),
            ],
          );

    if (context.isCupertino) {
      return SizedBox(
        height: height ?? 50,
        width: expandWidth ? double.maxFinite : width,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: activeColor, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(Sizes.p8)),
          ),
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
            onPressed: isLoading ? null : tapCallback,
            child: Center(child: childWidget),
          ),
        ),
      );
    }

    return SizedBox(
      height: height ?? 50,
      width: expandWidth ? double.maxFinite : width,
      child: OutlinedButton(
        onPressed: isLoading ? null : tapCallback,
        style: OutlinedButton.styleFrom(elevation: elevation).copyWith(
          side: WidgetStateProperty.all(
            BorderSide(color: activeColor, width: 1.5),
          ),
        ),
        child: childWidget,
      ),
    );
  }
}
