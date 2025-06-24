import 'dart:ui';

class PieParameter {
  final double value;
  final String title;
  final String? subtitle;
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
