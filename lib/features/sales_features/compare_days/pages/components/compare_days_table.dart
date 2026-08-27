import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/sales_features/compare_days/controllers/controllers.dart';
import 'package:celta_dash/features/sales_features/compare_days/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompareDaysTable extends ConsumerWidget {
  const CompareDaysTable({
    super.key,
    required this.state,
    required this.isLoading,
    required this.provider,
  });

  final CompareDaysState state;
  final bool isLoading;
  final CompareDaysControllerProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dates = ref.watch(compareDaysDatesControllerProvider);
    final firstDay = dates.firstDay;
    final secondDay = dates.secondDay;

    final rows = _makeRows();
    final firstDayTotal = rows.fold<num>(
      0,
      (total, row) => total + row.firstDayValue,
    );
    final secondDayTotal = rows.fold<num>(
      0,
      (total, row) => total + row.secondDayValue,
    );
    final totalDifference = CompareDaysRowState(
      hour: 0,
      firstDayValue: firstDayTotal,
      secondDayValue: secondDayTotal,
    ).percentageDifference;

    return ScrollableTable<CompareDaysRowState>(
      items: rows,
      fixFirstColumn: true,
      isLoading: isLoading,
      highlightColumnIndex: 3,
      pdfFileName: 'Comparativo diário'.hardcoded,
      refreshProvider: provider,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Hora'.hardcoded,
          cellBuilder: (row) => BaseText.bodyMedium(
            '${row.hour.toString().padLeft(2, '0')}:00 ~ ${row.hour.toString().padLeft(2, '0')}:59',
          ),
          sortValueMapper: (row) => row.hour,
          textValueMapper: (row) =>
              '${row.hour.toString().padLeft(2, '0')}:00 ~ ${row.hour.toString().padLeft(2, '0')}:59',
        ),
        ScrollableTableColumnSpec(
          headerTitle: firstDay.formatDate(),
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.firstDayValue.toString().toBRL()),
          sortValueMapper: (row) => row.firstDayValue,
          footerCellBuilder: (rows) => BaseText.bodyMedium(
            rows
                .fold<num>(0, (total, row) => total + row.firstDayValue)
                .toString()
                .toBRL(),
          ),
          footerTextValueMapper: (rows) => rows
              .fold<num>(0, (total, row) => total + row.firstDayValue)
              .toString()
              .toBRL(),
        ),
        ScrollableTableColumnSpec(
          headerTitle: secondDay.formatDate(),
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.secondDayValue.toString().toBRL()),
          sortValueMapper: (row) => row.secondDayValue,
          footerCellBuilder: (rows) => BaseText.bodyMedium(
            rows
                .fold<num>(0, (total, row) => total + row.secondDayValue)
                .toString()
                .toBRL(),
          ),
          footerTextValueMapper: (rows) => rows
              .fold<num>(0, (total, row) => total + row.secondDayValue)
              .toString()
              .toBRL(),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Dif'.hardcoded,
          isPercentage: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.percentageDifference.toString().toBRL()),
          sortValueMapper: (row) => row.percentageDifference,
          footerCellBuilder: (_) =>
              BaseText.bodyMedium(totalDifference.toString().toBRL()),
          footerTextValueMapper: (_) => totalDifference.toString().toBRL(),
        ),
      ],
    );
  }

  List<CompareDaysRowState> _makeRows() {
    final hours = <int>{
      ...state.firstDayStatistics.map((item) => item.Hour).whereType<int>(),
      ...state.secondDayStatistics.map((item) => item.Hour).whereType<int>(),
    }.toList()..sort();

    return hours
        .map(
          (hour) => CompareDaysRowState(
            hour: hour,
            firstDayValue: _totalForHour(state.firstDayStatistics, hour),
            secondDayValue: _totalForHour(state.secondDayStatistics, hour),
          ),
        )
        .toList();
  }

  num _totalForHour(List<SaleStatisticsEntity> statistics, int hour) =>
      statistics
          .where((item) => item.Hour == hour)
          .fold(0, (total, item) => total + (item.LiquidValue ?? 0));
}
