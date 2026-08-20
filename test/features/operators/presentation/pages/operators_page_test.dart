import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/operators/operators.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../../home/mocks/mocks.dart';

void main() {
  late MockSaleStatisticsRepository repository;
  late EcParams ecParams;
  final selectedDate = DateTime(2026, 8, 20);
  const enterpriseId = 10;

  GetSaleStatisticsParams makeParams(OperatorsPeriod period) {
    switch (period) {
      case OperatorsPeriod.daily:
        final date = DateTime(2026, 8, 20);
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: date,
          endDate: date,
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByDay: true,
        );
      case OperatorsPeriod.monthly:
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: DateTime(2026, 8),
          endDate: DateTime(2026, 8, 31),
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByMonth: true,
        );
      case OperatorsPeriod.yearly:
        return GetSaleStatisticsParams(
          enterpriseIds: const [enterpriseId],
          startDate: DateTime(2026),
          endDate: DateTime(2026, 12, 31),
          groupByEnterprise: true,
          groupByCashierOperator: true,
          groupByYear: true,
        );
    }
  }

  setUp(() {
    repository = MockSaleStatisticsRepository();
    ecParams = EntityFactory.makeEcParams();
    for (final period in OperatorsPeriod.values) {
      final params = makeParams(period);
      when(
        () => repository.getSaleStatistics(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => []);
    }
  });

  testWidgets('loads month and year only after their tabs are tapped', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeEcParamsStateControllerProvider.overrideWith(
            () => FakeActiveEcParams(ecParams),
          ),
          homeControllerProvider.overrideWith(
            () => FakeHomeController(
              HomeState.initial(appMode: AppMode.sales).copyWith(
                selectedEnterpriseId: enterpriseId,
                selectedDate: selectedDate,
              ),
            ),
          ),
          saleStatisticsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: Scaffold(body: OperatorsPage())),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final dailyParams = makeParams(OperatorsPeriod.daily);
    final monthlyParams = makeParams(OperatorsPeriod.monthly);
    final yearlyParams = makeParams(OperatorsPeriod.yearly);
    verify(
      () =>
          repository.getSaleStatistics(params: dailyParams, ecParams: ecParams),
    ).called(1);
    verifyNever(
      () => repository.getSaleStatistics(
        params: monthlyParams,
        ecParams: ecParams,
      ),
    );
    verifyNever(
      () => repository.getSaleStatistics(
        params: yearlyParams,
        ecParams: ecParams,
      ),
    );

    await tester.tap(find.text('Mês'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    verify(
      () => repository.getSaleStatistics(
        params: monthlyParams,
        ecParams: ecParams,
      ),
    ).called(1);
    verifyNever(
      () => repository.getSaleStatistics(
        params: yearlyParams,
        ecParams: ecParams,
      ),
    );

    await tester.tap(find.text('Ano'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    verify(
      () => repository.getSaleStatistics(
        params: yearlyParams,
        ecParams: ecParams,
      ),
    ).called(1);
  });
}
