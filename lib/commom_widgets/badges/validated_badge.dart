import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ValidatedBadge extends StatelessWidget {
  final bool isValid;
  final PlatformIcon platformIcon;
  final bool isSelected;
  final bool showSuccessBadge;
  const ValidatedBadge({
    super.key,
    required this.isValid,
    required this.platformIcon,
    this.isSelected = false,
    this.showSuccessBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      offset: const Offset(8, -6),
      backgroundColor: Colors.transparent,
      label: isValid && !showSuccessBadge
          ? null
          : PlatformIcon(
              cupertinoIcon: isValid
                  ? CupertinoIcons.checkmark
                  : CupertinoIcons.clear,
              materialIcon: isValid ? Icons.check : Icons.close,
              color: isValid ? Colors.green : Colors.red,
              size: 17,
            ),
      child: PlatformIcon(
        cupertinoIcon: platformIcon.cupertinoIcon,
        materialIcon: platformIcon.materialIcon,
        size: platformIcon.size,
        color: isSelected
            ? context.theme.primaryColor
            : context.theme.disabledColor,
      ),
    );
  }
}
