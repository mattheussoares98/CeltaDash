import 'package:flutter/cupertino.dart';

import '../components.dart';

class BodyRows extends StatefulWidget {
  final ScrollController fixedColumnScrollController;
  final ScrollController scrollableColumnsScrollController;
  final ScrollController bodyHorizontalController;
  final Color tableBorderColor;
  final double columnWidth;
  final List<List<PersonalizedTableCell>> fixedRowValues;
  final List<List<PersonalizedTableCell>> sortedRows;
  final Map<int, TableColumnWidth> scrollableColumnWidthsMap;
  final List<List<PersonalizedTableCell>> scrollableRowValues;
  final ScrollableTableItem widget;
  final bool alreadyShowedAnimation;
  final double availableSize;
  final List<TableRow> fixedColumns;
  final List<TableRow> notFixedColumns;
  const BodyRows({
    super.key,
    required this.fixedColumnScrollController,
    required this.scrollableColumnsScrollController,
    required this.bodyHorizontalController,
    required this.tableBorderColor,
    required this.columnWidth,
    required this.fixedRowValues,
    required this.sortedRows,
    required this.scrollableColumnWidthsMap,
    required this.scrollableRowValues,
    required this.widget,
    required this.alreadyShowedAnimation,
    required this.availableSize,
    required this.fixedColumns,
    required this.notFixedColumns,
  });

  @override
  State<BodyRows> createState() => _BodyRowsState();
}

class _BodyRowsState extends State<BodyRows> {
  bool alreadyShowedAnimation = false;

  @override
  Widget build(BuildContext context) {
    final cupertinoTextStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return Flexible(
      child: Stack(
        children: [
          Row(
            children: [
              if (widget.widget.fixFirstColumn)
                SingleChildScrollView(
                  controller: widget.fixedColumnScrollController,
                  child: DefaultTextStyle(
                    style: cupertinoTextStyle,
                    child: Table(
                      border: TableBorder.all(
                          color: widget.tableBorderColor, width: 0.06),
                      defaultColumnWidth: const FlexColumnWidth(1),
                      columnWidths: {0: FixedColumnWidth(widget.columnWidth)},
                      children: widget.fixedColumns,
                    ),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  controller: widget.scrollableColumnsScrollController,
                  physics: const ClampingScrollPhysics(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: widget.bodyHorizontalController,
                    physics: const ClampingScrollPhysics(),
                    child: DefaultTextStyle(
                      style: cupertinoTextStyle,
                      child: Table(
                        border: TableBorder.all(
                            color: widget.tableBorderColor, width: 0.06),
                        defaultColumnWidth: const FlexColumnWidth(1),
                        columnWidths: widget.scrollableColumnWidthsMap,
                        children: widget.notFixedColumns,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (widget.availableSize == 0 &&
              widget.widget.showAnimation &&
              !widget.alreadyShowedAnimation)
            Builder(builder: (context) {
              final animationDuration = Duration(
                  seconds:
                      (widget.widget.animationSecondsDuration / 2).toInt());

              if (widget.bodyHorizontalController.hasClients) {
                widget.bodyHorizontalController.animateTo(
                  curve: Curves.linear,
                  duration: animationDuration,
                  widget.widget.columnsWidths.reduce((p, e) => p + e),
                );
              }
              Future.delayed(animationDuration, () async {
                if (widget.bodyHorizontalController.hasClients) {
                  await widget.bodyHorizontalController.animateTo(
                    curve: Curves.linear,
                    duration: animationDuration,
                    0,
                  );
                  if (mounted) {
                    setState(() {
                      alreadyShowedAnimation = true;
                    });
                  }
                }
              });

              widget.widget.hideShowAnimation();

              return Positioned(
                bottom: 0,
                top: 0,
                left: widget.widget.columnsWidths.first,
                child: const HorizontalScrollableIndicator(),
              );
            }),
        ],
      ),
    );
  }
}
