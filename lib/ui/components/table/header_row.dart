import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'table.dart';

class HeaderRow extends StatelessWidget {
  final List<PersonalizedTableCell> fullSumRow;
  final double titleMinHeight;
  final bool fixFirstColumn;
  final Color tableBorderColor;
  final double fixedColumnWidth;
  final void Function(int index) onTap;
  final BorderDirectional borderDecoration;
  final Color disabledColor;
  final List<PersonalizedTableCell> fixedTitles;
  final ScrollController headerHorizontalController;
  final Map<int, TableColumnWidth> scrollableColumnWidthsMap;
  final List<PersonalizedTableCell> scrollableTitles;
  final VoidCallback openPdfPage;
  const HeaderRow({
    super.key,
    required this.fullSumRow,
    required this.titleMinHeight,
    required this.fixFirstColumn,
    required this.tableBorderColor,
    required this.fixedColumnWidth,
    required this.onTap,
    required this.borderDecoration,
    required this.disabledColor,
    required this.fixedTitles,
    required this.headerHorizontalController,
    required this.scrollableColumnWidthsMap,
    required this.scrollableTitles,
    required this.openPdfPage,
  });

  @override
  Widget build(BuildContext context) {
    final cupertinoTextStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return SizedBox(
      height: titleMinHeight,
      child: DefaultTextStyle(
        style: cupertinoTextStyle,
        child: Stack(
          children: [
            Row(
              children: [
                if (fixFirstColumn)
                  Table(
                    border:
                        TableBorder.all(color: tableBorderColor, width: 0.06),
                    defaultColumnWidth: const FlexColumnWidth(1),
                    columnWidths: {0: FixedColumnWidth(fixedColumnWidth)},
                    children: [
                      TableRow(
                        children: [
                          IntrinsicHeight(
                            child: InkWell(
                              onTap: () => onTap(0),
                              child: Container(
                                constraints:
                                    BoxConstraints(minHeight: titleMinHeight),
                                decoration: BoxDecoration(
                                  border: borderDecoration,
                                  color: disabledColor,
                                ),
                                child: fixedTitles[0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: headerHorizontalController,
                    physics: const ClampingScrollPhysics(),
                    child: Table(
                      border:
                          TableBorder.all(color: tableBorderColor, width: 0.06),
                      defaultColumnWidth: const FlexColumnWidth(1),
                      columnWidths: scrollableColumnWidthsMap,
                      children: [
                        TableRow(
                          children:
                              List.generate(scrollableTitles.length, (index) {
                            final originalIndex =
                                fixFirstColumn ? index + 1 : index;
                            final tableCell = scrollableTitles[index];
                            return IntrinsicHeight(
                              child: InkWell(
                                onTap: () => onTap(originalIndex),
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: titleMinHeight,
                                  ),
                                  decoration: BoxDecoration(
                                    border: borderDecoration,
                                    color: disabledColor,
                                  ),
                                  child: tableCell,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              top: 0,
              child: InkWell(
                onTap: openPdfPage,
                child: const Icon(Icons.picture_as_pdf_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
