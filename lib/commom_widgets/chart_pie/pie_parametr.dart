import 'package:flutter/widgets.dart';

class PieParameter {
  final double value;
  final Widget title;
  final Widget? subtitle;
  final bool showSubtitleOnlyOnTap;
  final Color? color;

  PieParameter({
    required this.value,
    required this.title,
    this.subtitle,
    this.showSubtitleOnlyOnTap = false,
    this.color,
  });
}
