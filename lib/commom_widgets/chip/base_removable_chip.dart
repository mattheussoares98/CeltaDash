import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseRemovableChip extends StatelessWidget {
  const BaseRemovableChip({
    super.key,
    required this.label,
    required this.onRemove,
    this.iconSize = 14,
  });

  final String label;
  final VoidCallback onRemove;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: BaseText(label),
      deleteIcon: PlatformIcon(
        materialIcon: Icons.close,
        cupertinoIcon: CupertinoIcons.clear,
        color: Colors.red,
        size: iconSize,
      ),
      onDeleted: onRemove,
    );
  }
}
