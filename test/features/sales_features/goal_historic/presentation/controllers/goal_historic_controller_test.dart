import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sales_features/goal_historic/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sales_features/goal_historic/presentation/models/models.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/presentation/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../domain/mocks/mocks.dart';
import '../../../../../presentation/fake_controllers/fake_controllers.dart';

class _FakeSaleStatisticsController extends SaleStatisticsController {
  _FakeSaleStatisticsController(this._response);

  final List<SaleStatisticsEntity> _response;

  @override
  AsyncValue<List<SaleStatisticsEntity>> build(
    CategoryGroupingType? categoryGroupingType, {
    PeriodGroupingType? periodGroupingType,
    SaleStatisticsSeriesType seriesType = SaleStatisticsSeriesType.primary,
  }) {
    return AsyncData(_response);
  }

  @override
  Future<AsyncValue<List<SaleStatisticsEntity>>> loadStatistics({
    required GetSaleStatisticsParams params,
    bool forceRefresh = false,
  }) async {
    state = AsyncData(_response);
    return state;
  }
}

class _FakeMonthlyGoalsController extends MonthlyGoalsController {
  _FakeMonthlyGoalsController(this._goals);

  final Map<MonthlyGoalKey, MonthlyGoalEntity> _goals;

  @override
  Future<Map<MonthlyGoalKey, MonthlyGoalEntity>> build() async => _goals;
}

void main() {
  group('GoalHistoricYearController', () {
    test('initializes with current year (>= 2025)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final year = container.read(goalHistoricYearControllerProvider);
      expect(year, greaterThanOrEqualTo(2025));
    });

    test('selectYear updates state for valid years', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(
        goalHistoricYearControllerProvider.notifier,
      );
      notifier.selectYear(2026);

      expect(container.read(goalHistoricYearControllerProvider), 2026);
    });

    test('selectYear ignores years before 2025', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(
        goalHistoricYearControllerProvider.notifier,
      );
      notifier.selectYear(2026);
      notifier.selectYear(2024);

      expect(container.read(goalHistoricYearControllerProvider), 2026);
    });
  });

  group('GoalHistoricRowState and GoalHistoricState', () {
    test('computes percentage and goal reached correctly', () {
      const rowReached = GoalHistoricRowState(
        year: 2026,
        month: 1,
        goalValue: 1000.0,
        salesValue: 1200.0,
      );
      expect(rowReached.percentageValue, 120.0);
      expect(rowReached.isGoalReached, isTrue);

      const rowNotReached = GoalHistoricRowState(
        year: 2026,
        month: 2,
        goalValue: 1000.0,
        salesValue: 800.0,
      );
      expect(rowNotReached.percentageValue, 80.0);
      expect(rowNotReached.isGoalReached, isFalse);

      const state = GoalHistoricState(
        selectedYear: 2026,
        rows: [rowReached, rowNotReached],
      );
      expect(state.totalGoal, 2000.0);
      expect(state.totalSales, 2000.0);
      expect(state.totalPercentage, 100.0);
    });
  });

  group('GoalHistoricController', () {
    test(
      'calculates goals combining manual custom goals and +5% automatic goals',
      () async {
        const enterpriseId = 1;
        final customGoal = MonthlyGoalEntity(
          enterpriseId: enterpriseId,
          month: DateTime(2026, 2),
          value: 50000.0,
          userName: 'Admin',
        );

        final currentYearSales = [
          EntityFactory.makeSaleStatisticEntity(
            enterpriseId: enterpriseId,
            year: 2026,
            month: 1,
          ).copyWith(Date: DateTime(2026, 1, 15), LiquidValue: 10000.0),
          EntityFactory.makeSaleStatisticEntity(
            enterpriseId: enterpriseId,
            year: 2026,
            month: 2,
          ).copyWith(Date: DateTime(2026, 2, 15), LiquidValue: 45000.0),
        ];

        final previousYearSales = [
          EntityFactory.makeSaleStatisticEntity(
            enterpriseId: enterpriseId,
            year: 2025,
            month: 1,
          ).copyWith(Date: DateTime(2025, 1, 15), LiquidValue: 8000.0),
        ];

        final container = ProviderContainer(
          overrides: [
            activeEcParamsStateControllerProvider.overrideWith(
              () => FakeActiveEcParams(EntityFactory.makeEcParams()),
            ),
            goalHistoricYearControllerProvider.overrideWith(
              () => GoalHistoricYearController(),
            ),
            monthlyGoalsControllerProvider.overrideWith(
              () => _FakeMonthlyGoalsController({
                const MonthlyGoalKey(
                  enterpriseId: enterpriseId,
                  year: 2026,
                  month: 2,
                ): customGoal,
              }),
            ),
            saleStatisticsControllerProvider(
              null,
              periodGroupingType: PeriodGroupingType.month,
            ).overrideWith(
              () => _FakeSaleStatisticsController(currentYearSales),
            ),
            saleStatisticsControllerProvider(
              null,
              periodGroupingType: PeriodGroupingType.month,
              seriesType: SaleStatisticsSeriesType.comparison,
            ).overrideWith(
              () => _FakeSaleStatisticsController(previousYearSales),
            ),
          ],
        );
        addTearDown(container.dispose);

        container
            .read(goalHistoricYearControllerProvider.notifier)
            .selectYear(2026);

        final state = await container.read(
          goalHistoricControllerProvider(enterpriseId).future,
        );

        expect(state.selectedYear, 2026);
        expect(state.rows.length, 2);

        // Month 1: Automatic goal from previous year sales (8000 * 1.05 = 8400)
        final month1 = state.rows.firstWhere((r) => r.month == 1);
        expect(month1.goalValue, 8400.0);
        expect(month1.salesValue, 10000.0);
        expect(month1.isCustomGoal, isFalse);
        expect(month1.customGoalAuthor, isNull);

        // Month 2: Custom goal from monthly goals provider
        final month2 = state.rows.firstWhere((r) => r.month == 2);
        expect(month2.goalValue, 50000.0);
        expect(month2.salesValue, 45000.0);
        expect(month2.isCustomGoal, isTrue);
        expect(month2.customGoalAuthor, 'Admin');
      },
    );

    test(
      'correctly extracts month and sales when Date is null and Month is integer',
      () async {
        const enterpriseId = 1;
        final currentYearSales = [
          EntityFactory.makeSaleStatisticEntity(
            enterpriseId: enterpriseId,
            year: 2026,
            month: 8,
            nullDate: true,
          ).copyWith(LiquidValue: 75000.0),
        ];

        final previousYearSales = [
          EntityFactory.makeSaleStatisticEntity(
            enterpriseId: enterpriseId,
            year: 2025,
            month: 8,
            nullDate: true,
          ).copyWith(LiquidValue: 60000.0),
        ];

        final container = ProviderContainer(
          overrides: [
            activeEcParamsStateControllerProvider.overrideWith(
              () => FakeActiveEcParams(EntityFactory.makeEcParams()),
            ),
            goalHistoricYearControllerProvider.overrideWith(
              () => GoalHistoricYearController(),
            ),
            monthlyGoalsControllerProvider.overrideWith(
              () => _FakeMonthlyGoalsController(const {}),
            ),
            saleStatisticsControllerProvider(
              null,
              periodGroupingType: PeriodGroupingType.month,
            ).overrideWith(
              () => _FakeSaleStatisticsController(currentYearSales),
            ),
            saleStatisticsControllerProvider(
              null,
              periodGroupingType: PeriodGroupingType.month,
              seriesType: SaleStatisticsSeriesType.comparison,
            ).overrideWith(
              () => _FakeSaleStatisticsController(previousYearSales),
            ),
          ],
        );
        addTearDown(container.dispose);

        container
            .read(goalHistoricYearControllerProvider.notifier)
            .selectYear(2026);

        final state = await container.read(
          goalHistoricControllerProvider(enterpriseId).future,
        );

        expect(state.rows.length, 1);
        final augustRow = state.rows.first;
        expect(augustRow.month, 8);
        expect(augustRow.salesValue, 75000.0);
        expect(augustRow.goalValue, 63000.0); // 60000 * 1.05 = 63000
        expect(augustRow.isCustomGoal, isFalse);
      },
    );
  });
}
