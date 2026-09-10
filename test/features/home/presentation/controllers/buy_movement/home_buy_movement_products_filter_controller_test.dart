import 'package:celta_dash/features/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('starts with the top-products defaults', () {
    expect(
      container.read(homeBuyMovementProductsFilterControllerProvider),
      const HomeBuyMovementProductsFilterState(),
    );
  });

  test('trims and clears the product name', () {
    final controller = container.read(
      homeBuyMovementProductsFilterControllerProvider.notifier,
    );

    controller.setProductName('  coffee  ');
    expect(controller.state.productName, 'coffee');

    controller.setProductName('   ');
    expect(controller.state.productName, isNull);
  });

  test('accepts only top counts from 1 through 500', () {
    final controller = container.read(
      homeBuyMovementProductsFilterControllerProvider.notifier,
    );

    controller.setTopCount(500);
    expect(controller.state.topCount, 500);
    expect(() => controller.setTopCount(0), throwsArgumentError);
    expect(() => controller.setTopCount(501), throwsArgumentError);
  });
}
