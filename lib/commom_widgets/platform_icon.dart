import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';

class PlatformIcon extends StatelessWidget {
  final IconData cupertinoIcon;
  final IconData materialIcon;
  final Color? color;
  final double? size;

  const PlatformIcon({
    super.key,
    required this.cupertinoIcon,
    required this.materialIcon,
    this.color,
    this.size,
  });

  PlatformIcon copyWith({
    IconData? cupertinoIcon,
    IconData? materialIcon,
    Color? color,
    double? size,
  }) {
    return PlatformIcon(
      cupertinoIcon: cupertinoIcon ?? this.cupertinoIcon,
      materialIcon: materialIcon ?? this.materialIcon,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      PlatformUtil.isCupertino ? cupertinoIcon : materialIcon,
      color: color,
      size: size,
    );
  }
}
