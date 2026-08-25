import 'package:celta_dash/features/sales_features/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sales_features/presentation/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compare_days_controller.g.dart';

@riverpod
class CompareDaysController extends _$CompareDaysController {
  @override
  Future<CompareDaysState> build(int enterpriseId) {
    ref.watch(compareDaysDatesControllerProvider);
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<CompareDaysState> _load() async {
    final dates = ref.read(compareDaysDatesControllerProvider);
    final firstProvider = saleStatisticsControllerProvider(
      null,
      periodGroupingType: .hour,
    );
    final secondProvider = saleStatisticsControllerProvider(
      null,
      periodGroupingType: .hour,
      seriesType: .comparison,
    );
    final results = await Future.wait([
      ref
          .read(firstProvider.notifier)
          .loadStatistics(
            params: _makeParams(dates.firstDay),
            forceRefresh: true,
          ),
      ref
          .read(secondProvider.notifier)
          .loadStatistics(
            params: _makeParams(dates.secondDay),
            forceRefresh: true,
          ),
    ]);

    for (final result in results) {
      if (result.hasError) {
        Error.throwWithStackTrace(result.error!, result.stackTrace!);
      }
    }

    return CompareDaysState(
      firstDayStatistics: results.first.requireValue,
      secondDayStatistics: results.last.requireValue,
    );
  }

  GetSaleStatisticsParams _makeParams(DateTime date) => GetSaleStatisticsParams(
    startDate: _dateOnly(date),
    endDate: _dateOnly(date),
    enterpriseIds: [enterpriseId],
    groupByEnterprise: true,
    groupByHour: true,
  );

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
