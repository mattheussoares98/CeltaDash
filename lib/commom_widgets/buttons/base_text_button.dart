import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Primary button based on [ElevatedButton].
/// Useful for CTAs in the app.
/// @param text - text to display on the button.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class PrimaryTextButton extends StatelessWidget {
  const PrimaryTextButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
    this.platformIcon,
    this.iconAlignment = IconAlignment.end,
    this.color,
    this.isSmall,
    this.textAlign = TextAlign.center,
  });
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final PlatformIcon? platformIcon;
  final IconAlignment? iconAlignment;
  final Color? color;
  final TextAlign? textAlign;
  final bool? isSmall;

  @override
  Widget build(BuildContext context) {
    final isIOS = PlatformUtil.isCupertino;

    final iconColor = isLoading || onPressed == null
        ? context.theme.disabledColor
        : color ?? context.theme.primaryColor;

    final textColor = onPressed == null
        ? context.theme.disabledColor
        : isLoading
        ? Colors.transparent
        : color ?? context.theme.primaryColor;

    final textWidget = BaseText(
      text,
      textAlign: textAlign,
      textType: isSmall == true ? TextType.titleSmall : TextType.titleMedium,
      color: textColor,
    );
    final iconWidget = platformIcon == null
        ? null
        : IconTheme(
            data: IconThemeData(
              color: iconColor,
              size: isSmall == true ? 16 : 24,
            ),
            child: platformIcon!,
          );

    final minimumSizeToShowIcon = isSmall == true ? 60 : 150;

    if (isIOS) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final canShowIcon = constraints.maxWidth > minimumSizeToShowIcon;

          return CupertinoButton(
            onPressed: onPressed == null || isLoading
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onPressed?.call();
                  },
            sizeStyle: CupertinoButtonSize.small,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWidget,
                    if (platformIcon != null && canShowIcon) ...[
                      gapW8,
                      iconWidget!,
                    ],
                  ],
                ),
                if (isLoading)
                  const Positioned.fill(
                    child: FittedBox(child: LoadingWidget()),
                  ),
              ],
            ),
          );
        },
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final canShowIcon = constraints.maxWidth > minimumSizeToShowIcon;

        return TextButton.icon(
          onPressed: onPressed == null || isLoading
              ? null
              : () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  onPressed?.call();
                },
          icon: canShowIcon ? iconWidget : null,
          iconAlignment: iconAlignment,
          label: Stack(
            children: [
              FittedBox(child: textWidget),
              if (isLoading)
                const Positioned.fill(child: FittedBox(child: LoadingWidget())),
            ],
          ),
        );
      },
    );
  }
}
