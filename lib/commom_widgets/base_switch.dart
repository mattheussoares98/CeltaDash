import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseSwitch extends StatelessWidget {
  final Widget title;
  final bool value;
  final void Function(bool)? onChanged;
  const BaseSwitch({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtil.isCupertino) {
      return CupertinoListTile(
        title: title,
        padding: EdgeInsets.zero,
        trailing: CupertinoSwitch(value: value, onChanged: onChanged),
      );
    } else {
      return SwitchListTile.adaptive(
        dense: true,
        contentPadding: EdgeInsetsGeometry.zero,
        title: title,
        value: value,
        onChanged: onChanged,
      );
    }
  }
}
