import 'package:celta_dash/features/sales_features/compare_days/controllers/controllers.dart';
import 'package:celta_dash/features/sales_features/compare_days/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.now();
  ProviderContainer makeContainer() => ProviderContainer(overrides: []);

  test('starts with yesterday and today without time values', () {
    final container = makeContainer();
    addTearDown(container.dispose);

    expect(
      container.read(compareDaysDatesControllerProvider),
      CompareDaysDatesState(
        firstDay: DateTime(now.year, now.month, now.day - 1),
        secondDay: DateTime(now.year, now.month, now.day),
      ),
    );
  });

  test('selectFirstDay normalizes and updates a valid date', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final subscription = container.listen(
      compareDaysDatesControllerProvider,
      (_, _) {},
    );
    addTearDown(subscription.close);
    final controller = container.read(
      compareDaysDatesControllerProvider.notifier,
    );

    final newDate = faker.date.dateTime();
    final error = controller.selectFirstDay(newDate);

    expect(error, isNull);
    expect(
      container.read(compareDaysDatesControllerProvider).firstDay,
      DateTime(newDate.year, newDate.month, newDate.day),
    );
  });

  test('selectFirstDay rejects the selected second day', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final subscription = container.listen(
      compareDaysDatesControllerProvider,
      (_, _) {},
    );
    addTearDown(subscription.close);
    final initialState = container.read(compareDaysDatesControllerProvider);
    final controller = container.read(
      compareDaysDatesControllerProvider.notifier,
    );

    final error = controller.selectFirstDay(now);

    expect(error, 'Os dias selecionados devem ser diferentes');
    expect(container.read(compareDaysDatesControllerProvider), initialState);
  });

  test('selectSecondDay normalizes and updates a valid date', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final subscription = container.listen(
      compareDaysDatesControllerProvider,
      (_, _) {},
    );
    addTearDown(subscription.close);
    final controller = container.read(
      compareDaysDatesControllerProvider.notifier,
    );

    final error = controller.selectSecondDay(DateTime(2026, 8, 15, 8, 10));

    expect(error, isNull);
    expect(
      container.read(compareDaysDatesControllerProvider).secondDay,
      DateTime(2026, 8, 15),
    );
  });
}
