// test/features/home/presentation/controllers/personalized_controller_test.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../../home/mocks/mocks.dart';

void main() {
  late MockSaleStatisticsRepository repository;
  late EcParams ecParams;
  late SaleStatisticsEntity statistic;
  late ProviderContainer container;

  final startDate = DateTime(2026, 8);
  final endDate = DateTime(2026, 8, 2);
  const enterpriseId = 42;

  setUp(() {
    repository = MockSaleStatisticsRepository();
    ecParams = EntityFactory.makeEcParams();
    statistic = EntityFactory.makeSaleStatisticEntity();

    container = ProviderContainer(
      overrides: [
        activeEcParamsStateControllerProvider.overrideWith(
          () => FakeActiveEcParams(ecParams),
        ),
        saleStatisticsRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PersonalizedController State Mutations', () {
    test('initial state has empty/null defaults', () {
      final state = container.read(personalizedControllerProvider);

      expect(state.startDate, isNull);
      expect(state.endDate, isNull);
      expect(state.selectedEnterpriseId, isNull);
      expect(state.periodGrouping, isNull);
      expect(state.categoryGroupings, isEmpty);
      expect(state.sales.value, isEmpty);
      expect(state.validationError, isNull);
      expect(state.hasValidDateRange, isFalse);
      expect(state.canGenerate, isFalse);
      expect(state.isGenerating, isFalse);
    });

    test('setDateRange updates startDate and endDate and clears error', () {
      final controller = container.read(personalizedControllerProvider.notifier);

      controller.setDateRange(startDate, endDate);
      final state = container.read(personalizedControllerProvider);

      expect(state.startDate, startDate);
      expect(state.endDate, endDate);
      expect(state.hasValidDateRange, isTrue);
    });

    test('selectEnterprise updates selectedEnterpriseId', () {
      final controller = container.read(personalizedControllerProvider.notifier);

      controller.selectEnterprise(enterpriseId);
      final state = container.read(personalizedControllerProvider);

      expect(state.selectedEnterpriseId, enterpriseId);
    });

    test('setPeriodGrouping sets and toggles off period grouping', () {
      final controller = container.read(personalizedControllerProvider.notifier);

      controller.setPeriodGrouping(PeriodGroupingType.day);
      expect(
        container.read(personalizedControllerProvider).periodGrouping,
        PeriodGroupingType.day,
      );

      // Toggling same again clears it
      controller.setPeriodGrouping(PeriodGroupingType.day);
      expect(
        container.read(personalizedControllerProvider).periodGrouping,
        isNull,
      );

      // Passing null clears it
      controller.setPeriodGrouping(PeriodGroupingType.month);
      controller.setPeriodGrouping(null);
      expect(
        container.read(personalizedControllerProvider).periodGrouping,
        isNull,
      );
    });

    test('toggleCategoryGrouping handles standalone categories', () {
      final controller = container.read(personalizedControllerProvider.notifier);

      controller.toggleCategoryGrouping(CategoryGroupingType.product);
      expect(
        container.read(personalizedControllerProvider).categoryGroupings,
        {CategoryGroupingType.product},
      );

      // Toggling again removes it
      controller.toggleCategoryGrouping(CategoryGroupingType.product);
      expect(
        container.read(personalizedControllerProvider).categoryGroupings,
        isEmpty,
      );

      // Switching to cashierOperator sets only cashierOperator
      controller.toggleCategoryGrouping(CategoryGroupingType.cashierOperator);
      expect(
        container.read(personalizedControllerProvider).categoryGroupings,
        {CategoryGroupingType.cashierOperator},
      );

      // Switching to seller replaces cashierOperator
      controller.toggleCategoryGrouping(CategoryGroupingType.seller);
      expect(
        container.read(personalizedControllerProvider).categoryGroupings,
        {CategoryGroupingType.seller},
      );
    });

    test('toggleCategoryGrouping allows payment finalization and modality together', () {
      final controller = container.read(personalizedControllerProvider.notifier);

      controller.toggleCategoryGrouping(CategoryGroupingType.paymentFinalization);
      controller.toggleCategoryGrouping(CategoryGroupingType.paymentModality);

      expect(
        container.read(personalizedControllerProvider).categoryGroupings,
        {
          CategoryGroupingType.paymentFinalization,
          CategoryGroupingType.paymentModality,
        },
      );

      // Toggling off finalization leaves modality
      controller.toggleCategoryGrouping(CategoryGroupingType.paymentFinalization);
      expect(
        container.read(personalizedControllerProvider).categoryGroupings,
        {CategoryGroupingType.paymentModality},
      );
    });

    test('toggleCategoryGrouping allows department and section together', () {
      final controller = container.read(personalizedControllerProvider.notifier);

      controller.toggleCategoryGrouping(CategoryGroupingType.productDepartment);
      controller.toggleCategoryGrouping(CategoryGroupingType.productSection);

      expect(
        container.read(personalizedControllerProvider).categoryGroupings,
        {
          CategoryGroupingType.productDepartment,
          CategoryGroupingType.productSection,
        },
      );

      // Switching to product removes department & section
      controller.toggleCategoryGrouping(CategoryGroupingType.product);
      expect(
        container.read(personalizedControllerProvider).categoryGroupings,
        {CategoryGroupingType.product},
      );
    });
  });

  group('PersonalizedController Validations', () {
    test('generateReport fails when date range is missing', () async {
      final controller = container.read(personalizedControllerProvider.notifier);
      controller.selectEnterprise(enterpriseId);

      final result = await controller.generateReport();

      expect(result, isFalse);
      expect(
        container.read(personalizedControllerProvider).validationError,
        contains('Selecione o período'),
      );
    });

    test('generateReport fails when enterprise is missing', () async {
      final controller = container.read(personalizedControllerProvider.notifier);
      controller.setDateRange(startDate, endDate);

      final result = await controller.generateReport();

      expect(result, isFalse);
      expect(
        container.read(personalizedControllerProvider).validationError,
        contains('Selecione a empresa'),
      );
    });

    test('generateReport fails when end date is before start date', () async {
      final controller = container.read(personalizedControllerProvider.notifier);
      controller.setDateRange(DateTime(2026, 8, 10), DateTime(2026, 8, 5));
      controller.selectEnterprise(enterpriseId);

      final result = await controller.generateReport();

      expect(result, isFalse);
      expect(
        container.read(personalizedControllerProvider).validationError,
        contains('A data final não pode ser anterior à data inicial'),
      );
    });

    test('generateReport fails when hour grouping exceeds 3 days', () async {
      final controller = container.read(personalizedControllerProvider.notifier);
      controller.setDateRange(DateTime(2026, 8), DateTime(2026, 8, 10));
      controller.selectEnterprise(enterpriseId);
      controller.setPeriodGrouping(PeriodGroupingType.hour);

      final result = await controller.generateReport();

      expect(result, isFalse);
      expect(
        container.read(personalizedControllerProvider).validationError,
        contains('Intervalo muito longo para agrupar por hora'),
      );
    });

    test('generateReport fails when day grouping exceeds 60 days', () async {
      final controller = container.read(personalizedControllerProvider.notifier);
      controller.setDateRange(DateTime(2026), DateTime(2026, 4));
      controller.selectEnterprise(enterpriseId);
      controller.setPeriodGrouping(PeriodGroupingType.day);

      final result = await controller.generateReport();

      expect(result, isFalse);
      expect(
        container.read(personalizedControllerProvider).validationError,
        contains('Intervalo muito longo para agrupar por dia'),
      );
    });

    test('generateReport fails when month grouping exceeds 365 days', () async {
      final controller = container.read(personalizedControllerProvider.notifier);
      controller.setDateRange(DateTime(2024), DateTime(2026));
      controller.selectEnterprise(enterpriseId);
      controller.setPeriodGrouping(PeriodGroupingType.month);

      final result = await controller.generateReport();

      expect(result, isFalse);
      expect(
        container.read(personalizedControllerProvider).validationError,
        contains('Intervalo muito longo para agrupar por mês'),
      );
    });
  });

  group('PersonalizedController Execution', () {
    test('generateReport succeeds and stores results on valid params', () async {
      final controller = container.read(personalizedControllerProvider.notifier);
      controller.setDateRange(startDate, endDate);
      controller.selectEnterprise(enterpriseId);
      controller.setPeriodGrouping(PeriodGroupingType.day);
      controller.toggleCategoryGrouping(CategoryGroupingType.seller);

      final expectedParams = GetSaleStatisticsParams(
        startDate: startDate,
        endDate: endDate,
        enterpriseIds: const [enterpriseId],
        groupByDay: true,
        groupByMonth: false,
        groupByYear: false,
        groupByHour: false,
        groupByProduct: false,
        groupByProductDepartment: false,
        groupByProductSection: false,
        groupByPaymentFinalization: false,
        groupByPaymentModality: false,
        groupByCashierOperator: false,
        groupBySeller: true,
      );

      when(
        () => repository.getSaleStatistics(
          params: expectedParams,
          ecParams: ecParams,
        ),
      ).thenAnswer((_) async => [statistic]);

      final result = await controller.generateReport();

      expect(result, isTrue);
      final state = container.read(personalizedControllerProvider);
      expect(state.sales.value, [statistic]);
      expect(state.lastLoadedParams, expectedParams);
      expect(state.validationError, isNull);
    });

    test('generateReport sets sales error on repository failure', () async {
      final controller = container.read(personalizedControllerProvider.notifier);
      controller.setDateRange(startDate, endDate);
      controller.selectEnterprise(enterpriseId);

      final expectedParams = GetSaleStatisticsParams(
        startDate: startDate,
        endDate: endDate,
        enterpriseIds: const [enterpriseId],
        groupByDay: false,
        groupByMonth: false,
        groupByYear: false,
        groupByHour: false,
        groupByProduct: false,
        groupByProductDepartment: false,
        groupByProductSection: false,
        groupByPaymentFinalization: false,
        groupByPaymentModality: false,
        groupByCashierOperator: false,
        groupBySeller: false,
      );

      when(
        () => repository.getSaleStatistics(
          params: expectedParams,
          ecParams: ecParams,
        ),
      ).thenThrow(Exception('Server error'));

      final result = await controller.generateReport();

      expect(result, isFalse);
      final state = container.read(personalizedControllerProvider);
      expect(state.sales.hasError, isTrue);
    });
  });
}
