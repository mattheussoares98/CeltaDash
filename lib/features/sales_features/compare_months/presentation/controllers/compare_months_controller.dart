// lib/features/compare_months/presentation/controllers/compare_months_controller.dart
import 'package:celta_dash/features/sales_features/compare_months/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sales_features/compare_months/presentation/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compare_months_controller.g.dart';

@riverpod
class CompareMonthsController extends _$CompareMonthsController {
  @override
  Future<CompareMonthsState> build(int enterpriseId) {
    ref.watch(compareMonthsDatesControllerProvider);
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<CompareMonthsState> _load() async {
    final dates = ref.read(compareMonthsDatesControllerProvider);
    final firstProvider = saleStatisticsControllerProvider(
      null,
      periodGroupingType: .day,
    );
    final secondProvider = saleStatisticsControllerProvider(
      null,
      periodGroupingType: .day,
      seriesType: .comparison,
    );
    final results = await Future.wait([
      ref
          .read(firstProvider.notifier)
          .loadStatistics(
            params: _makeParams(dates.firstMonth),
            forceRefresh: true,
          ),
      ref
          .read(secondProvider.notifier)
          .loadStatistics(
            params: _makeParams(dates.secondMonth),
            forceRefresh: true,
          ),
    ]);

    for (final result in results) {
      if (result.hasError) {
        Error.throwWithStackTrace(result.error!, result.stackTrace!);
      }
    }

    return CompareMonthsState(
      firstMonthStatistics: results.first.requireValue,
      secondMonthStatistics: results.last.requireValue,
    );
  }

  GetSaleStatisticsParams _makeParams(DateTime month) =>
      GetSaleStatisticsParams(
        startDate: DateTime(month.year, month.month),
        endDate: DateTime(month.year, month.month + 1, 0),
        enterpriseIds: [enterpriseId],
        groupByEnterprise: true,
        groupByDay: true,
      );
}
