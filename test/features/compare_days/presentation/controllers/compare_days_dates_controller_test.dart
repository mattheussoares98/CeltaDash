import 'package:celta_dash/features/compare_days/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/compare_days/presentation/models/models.dart';
import 'package:celta_dash/features/home/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 8, 21, 14, 30);

  ProviderContainer makeContainer() => ProviderContainer(
    overrides: [resumeCurrentDateProvider.overrideWithValue(now)],
  );

  test('starts with yesterday and today without time values', () {
    final container = makeContainer();
    addTearDown(container.dispose);

    expect(
      container.read(compareDaysDatesControllerProvider),
      CompareDaysDatesState(
        firstDay: DateTime(2026, 8, 20),
        secondDay: DateTime(2026, 8, 21),
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

    final error = controller.selectFirstDay(DateTime(2026, 8, 10, 18, 45));

    expect(error, isNull);
    expect(
      container.read(compareDaysDatesControllerProvider).firstDay,
      DateTime(2026, 8, 10),
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

    final error = controller.selectFirstDay(DateTime(2026, 8, 21, 9));

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

  test('selectSecondDay rejects the selected first day', () {
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

    final error = controller.selectSecondDay(DateTime(2026, 8, 20, 22));

    expect(error, 'Os dias selecionados devem ser diferentes');
    expect(container.read(compareDaysDatesControllerProvider), initialState);
  });
}
