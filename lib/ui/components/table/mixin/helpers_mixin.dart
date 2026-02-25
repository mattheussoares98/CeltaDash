import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components.dart';

mixin HelpersMixin {
  final borderDecoration = const BorderDirectional(
    end: BorderSide(
      width: 0.5,
      color: Colors.white,
    ),
  );

  DateTime parseTime(String time) {
    final cleaned = time.replaceFirst(RegExp(r'\r?\n[\s\S]*$'), '');
    final parts = cleaned.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
    return DateTime(0, 1, 1, hour, minute);
  }

  TableRow buildTableRow(
    List<PersonalizedTableCell> cells, {
    required Color? rowColor,
    required bool isSumRow,
    required bool isUnifiedTapRow,
    required VoidCallback? unifiedTap,
    required int startingColumnIndex,
    required double titleMinHeight,
    required BuildContext context,
  }) {
    final rowChildren = List.generate(cells.length, (colIndex) {
      final cell = cells[colIndex];
      // The cell's absolute position in the original row (e.g., 0, 1, 2, ...)
      final absoluteCellIndex = startingColumnIndex + colIndex;

      // If it's a unified row, all cells use the single tap. Otherwise, each uses its own.
      final effectiveTap = isUnifiedTapRow ? unifiedTap : cell.onTap;

      bool showIndicator = false;
      if (effectiveTap != null && !isSumRow) {
        // If there's ONE tap for the whole row, show the icon ONLY on the FIRST column.
        if (isUnifiedTapRow && absoluteCellIndex == 0) {
          showIndicator = true;
        }
        // If there are MULTIPLE taps, show the icon on each specific cell that has a tap.
        else if (!isUnifiedTapRow && cell.onTap != null) {
          showIndicator = true;
        }
      }

      // Build the cell with a GestureDetector and a conditional Stack for the icon
      return GestureDetector(
        onTap: effectiveTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(border: borderDecoration),
              width: double.infinity,
              constraints: BoxConstraints(minHeight: titleMinHeight),
              child: cell,
            ),
            if (showIndicator)
              Positioned(
                left: 0,
                bottom: 0,
                child: Icon(
                  Platform.isIOS
                      ? CupertinoIcons.hand_point_right
                      : Icons.touch_app_outlined,
                  size: 14,
                  color: Theme.of(context).primaryColor.withAlpha(200),
                ),
              ),
          ],
        ),
      );
    }).toList();

    return TableRow(
      decoration: BoxDecoration(color: rowColor),
      children: rowChildren,
    );
  }
}
