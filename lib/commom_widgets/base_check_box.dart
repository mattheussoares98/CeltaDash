import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseCheckBox extends StatelessWidget {
  final String name;
  final Widget? subtitle;
  final bool enabled;
  final void Function(bool?)? onChanged;
  final double? width;
  final double? height;
  const BaseCheckBox({
    super.key,
    required this.name,
    this.subtitle,
    required this.enabled,
    required this.onChanged,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = PlatformUtil.isCupertino;
    if (width != null || height != null) {
      final size = width ?? height ?? Sizes.p20;
      return Semantics(
        label: name,
        checked: enabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onChanged == null ? null : () => onChanged!(!enabled),
          child: SizedBox(
            width: width,
            height: height,
            child: Center(
              child: AnimatedContainer(
                width: size,
                height: size,
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: enabled
                      ? context.theme.primaryColor
                      : context.theme.cardColor,
                  borderRadius: BorderRadius.circular(Sizes.p4),
                  border: Border.all(
                    color: enabled
                        ? context.theme.primaryColor
                        : context.theme.dividerColor.withAlpha(120),
                  ),
                ),
                child: enabled
                    ? Icon(
                        Icons.check,
                        color: context.theme.colorScheme.onPrimary,
                        size: size - 6,
                      )
                    : null,
              ),
            ),
          ),
        ),
      );
    }

    final checkBox = RepaintBoundary(
      child: AnimatedContainer(
        margin: const EdgeInsets.only(top: Sizes.p4),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: enabled
              ? context.theme.primaryColor.withAlpha(20)
              : context.theme.cardColor,
          borderRadius: BorderRadius.circular(Sizes.p12),
          border: Border.all(
            color: enabled
                ? context.theme.primaryColor
                : context.theme.dividerColor.withAlpha(40),
          ),
          boxShadow: [
            BoxShadow(
              color: context.theme.primaryColor.withAlpha(enabled ? 30 : 15),
              blurRadius: enabled ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.p12),
          child: isIOS
              ? CupertinoListTile(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p12,
                    vertical: Sizes.p4,
                  ),
                  title: BaseText(name),
                  subtitle: subtitle,
                  trailing: CupertinoSwitch(
                    value: enabled,
                    onChanged: onChanged,
                  ),
                )
              : Material(
                  color: Colors.transparent,
                  child: CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Sizes.p12,
                    ),
                    title: BaseText(name),
                    subtitle: subtitle,
                    value: enabled,
                    onChanged: onChanged,
                    dense: true,
                  ),
                ),
        ),
      ),
    );

    return checkBox;
  }
}
