import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final ShapeBorder? shape;
  final Color? tileColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool? dense;

  const BaseListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.shape,
    this.tileColor,
    this.contentPadding,
    this.dense,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtil.isCupertino) {
      return CupertinoListTile(
        leading: leading,
        title: title ?? const SizedBox.shrink(),
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        padding: contentPadding as EdgeInsets?,
        backgroundColor: tileColor,
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: ListTile(
          leading: leading,
          minLeadingWidth: Sizes.p40,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          onTap: onTap,
          shape: shape,
          tileColor: tileColor,
          contentPadding: contentPadding,
          dense: dense,
        ),
      );
    }
  }
}
