import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseRadio<T> extends StatelessWidget {
  final String name;
  final Widget? subtitle;
  final T value;
  final T groupValue;
  final void Function(T?)? onChanged;
  final bool toggleable;
  final Color? activeColor;

  const BaseRadio({
    super.key,
    required this.name,
    this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = PlatformUtil.isCupertino;
    final selected = value == groupValue;

    final title = BaseText(name);
    final appliedActiveColor = activeColor ?? context.theme.primaryColor;
    final radio = isIOS
        ? CupertinoListTile(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p12,
              vertical: Sizes.p4,
            ),
            title: title,
            subtitle: subtitle,
            trailing: CupertinoRadio<T>(
              value: value,
              toggleable: toggleable,
              activeColor: appliedActiveColor,
            ),
            onTap: onChanged != null
                ? () => onChanged!(selected ? null : value)
                : null,
          )
        : Material(
            color: Colors.transparent,
            child: RadioListTile<T>(
              contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
              title: title,
              subtitle: subtitle,
              value: value,
              toggleable: toggleable,
              dense: true,
              activeColor: appliedActiveColor,
            ),
          );

    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: (val) => onChanged?.call(val),
      child: AnimatedContainer(
        margin: const EdgeInsets.only(top: Sizes.p4),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: selected
              ? appliedActiveColor.withAlpha(20)
              : context.theme.cardColor,
          borderRadius: BorderRadius.circular(Sizes.p12),
          border: Border.all(
            color: selected
                ? appliedActiveColor
                : context.theme.dividerColor.withAlpha(40),
          ),
          boxShadow: [
            BoxShadow(
              color: context.theme.primaryColor.withAlpha(selected ? 30 : 15),
              blurRadius: selected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.p12),
          child: radio,
        ),
      ),
    );
  }
}
