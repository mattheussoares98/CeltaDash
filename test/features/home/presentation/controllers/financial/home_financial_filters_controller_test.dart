import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('starts with expiration and every situation selected', () {
    final state = container.read(homeFinancialFiltersControllerProvider);

    expect(state.periodType, FinancialTitlePeriodType.expiration);
    expect(state.situations, {...FinancialTitleSituation.values});
  });

  test('setPeriodType changes the selected period type', () {
    container
        .read(homeFinancialFiltersControllerProvider.notifier)
        .setPeriodType(FinancialTitlePeriodType.emission);

    expect(
      container.read(homeFinancialFiltersControllerProvider).periodType,
      FinancialTitlePeriodType.emission,
    );
  });

  test('toggleSituation removes and restores a situation', () {
    final controller = container.read(
      homeFinancialFiltersControllerProvider.notifier,
    );

    controller.toggleSituation(FinancialTitleSituation.open);
    expect(container.read(homeFinancialFiltersControllerProvider).situations, {
      FinancialTitleSituation.partiallySettled,
      FinancialTitleSituation.completelySettled,
    });

    controller.toggleSituation(FinancialTitleSituation.open);
    expect(container.read(homeFinancialFiltersControllerProvider).situations, {
      ...FinancialTitleSituation.values,
    });
  });
  test('toggleSituation should not remove all situations', () {
    final controller = container.read(
      homeFinancialFiltersControllerProvider.notifier,
    );

    controller.toggleSituation(FinancialTitleSituation.open);
    expect(container.read(homeFinancialFiltersControllerProvider).situations, {
      FinancialTitleSituation.partiallySettled,
      FinancialTitleSituation.completelySettled,
    });

    controller.toggleSituation(FinancialTitleSituation.completelySettled);
    expect(container.read(homeFinancialFiltersControllerProvider).situations, {
      FinancialTitleSituation.partiallySettled,
    });

    controller.toggleSituation(FinancialTitleSituation.partiallySettled);
    expect(container.read(homeFinancialFiltersControllerProvider).situations, {
      FinancialTitleSituation.partiallySettled,
    });
  });
}
