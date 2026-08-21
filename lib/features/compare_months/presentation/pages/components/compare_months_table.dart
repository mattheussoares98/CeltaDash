import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/features/compare_months/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/compare_months/presentation/models/models.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompareMonthsTable extends ConsumerWidget {
  const CompareMonthsTable({
    super.key,
    required this.state,
    required this.isLoading,
  });

  final CompareMonthsState state;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dates = ref.watch(compareMonthsDatesControllerProvider);
    final firstMonth = dates.firstMonth;
    final secondMonth = dates.secondMonth;

    final rows = _makeRows();

    return ScrollableTable<CompareMonthsRowState>(
      items: rows,
      fixFirstColumn: true,
      isLoading: isLoading,
      highlightColumnIndex: 1,
      columns: [
        ScrollableTableColumnSpec(
          headerTitle: 'Dia'.hardcoded,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.day.toString().padLeft(2, '0')),
          sortValueMapper: (row) => row.day,
        ),
        ScrollableTableColumnSpec(
          headerTitle: firstMonth.formatDate(.yMMM),
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.firstMonthValue.toString().toBRL()),
          sortValueMapper: (row) => row.firstMonthValue,
          footerCellBuilder: (rows) => BaseText.bodyMedium(
            rows
                .fold<num>(0, (total, row) => total + row.firstMonthValue)
                .toString()
                .toBRL(),
          ),
        ),
        ScrollableTableColumnSpec(
          headerTitle: secondMonth.formatDate(.yMMM),
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.secondMonthValue.toString().toBRL()),
          sortValueMapper: (row) => row.secondMonthValue,
          footerCellBuilder: (rows) => BaseText.bodyMedium(
            rows
                .fold<num>(0, (total, row) => total + row.secondMonthValue)
                .toString()
                .toBRL(),
          ),
        ),
        ScrollableTableColumnSpec(
          headerTitle: 'Dif'.hardcoded,
          isPercentage: true,
          cellBuilder: (row) =>
              BaseText.bodyMedium(row.percentageDifference.toString().toBRL()),
          sortValueMapper: (row) => row.percentageDifference,
        ),
      ],
    );
  }

  List<CompareMonthsRowState> _makeRows() {
    final days = <int>{
      ...state.firstMonthStatistics
          .map((item) => item.Date?.day)
          .whereType<int>(),
      ...state.secondMonthStatistics
          .map((item) => item.Date?.day)
          .whereType<int>(),
    }.toList()..sort();

    return days
        .map(
          (day) => CompareMonthsRowState(
            day: day,
            firstMonthValue: _totalForDay(state.firstMonthStatistics, day),
            secondMonthValue: _totalForDay(state.secondMonthStatistics, day),
          ),
        )
        .toList();
  }

  num _totalForDay(List<SaleStatisticsEntity> statistics, int day) => statistics
      .where((item) => item.Date?.day == day)
      .fold(0, (total, item) => total + (item.LiquidValue ?? 0));
}
