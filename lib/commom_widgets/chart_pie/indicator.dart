import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final Widget title;
  final Widget? subtitle;
  final bool showOnlyOnTap;
  final BoxShape? boxShape;
  final EdgeInsetsGeometry? padding;
  final void Function() changeSelectedIndex;
  final bool isSelected;
  final double indicatorSize;
  final double value;

  const Indicator({
    super.key,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.showOnlyOnTap,
    required this.boxShape,
    required this.padding,
    required this.changeSelectedIndex,
    required this.isSelected,
    required this.indicatorSize,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (showOnlyOnTap && !isSelected) return const SizedBox.shrink();

    return GestureDetector(
      onTap: changeSelectedIndex,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          children: [
            Container(
              width: isSelected ? indicatorSize * 1.3 : indicatorSize,
              height: isSelected ? indicatorSize * 1.3 : indicatorSize,
              decoration: BoxDecoration(
                shape: boxShape ?? BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [title, ?subtitle],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
