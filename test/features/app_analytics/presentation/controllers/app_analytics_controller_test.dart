import 'package:celta_dash/features/app_analytics/domain/domain.dart';
import 'package:celta_dash/features/app_analytics/presentation/presentation.dart';
import 'package:celta_dash/features/app_analytics/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockAppAnalyticsRepository repository;

  setUp(() => repository = MockAppAnalyticsRepository());

  test('build loads analytics for its period family key', () async {
    final period = DateTime(2026, 8);
    final analytics = [AppAnalyticsEntityFactory.makeAppAnalyticsEntity()];
    when(
      () => repository.getAnalytics(period),
    ).thenAnswer((_) async => analytics);
    final container = ProviderContainer(
      overrides: [
        appAnalyticsRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    expect(
      await container.read(appAnalyticsControllerProvider(period).future),
      analytics,
    );
    verify(() => repository.getAnalytics(period)).called(1);
  });

  test('refresh reloads analytics for the same period', () async {
    final period = DateTime(2026, 8);
    when(
      () => repository.getAnalytics(period),
    ).thenAnswer((_) async => const <AppAnalyticsEntity>[]);
    final container = ProviderContainer(
      overrides: [
        appAnalyticsRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await container.read(appAnalyticsControllerProvider(period).future);

    await container
        .read(appAnalyticsControllerProvider(period).notifier)
        .refresh();

    verify(() => repository.getAnalytics(period)).called(2);
  });
}
