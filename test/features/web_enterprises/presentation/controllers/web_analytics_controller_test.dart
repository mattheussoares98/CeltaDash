import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/features/web_enterprises/presentation/presentation.dart';
import 'package:celta_dash/features/web_enterprises/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockWebEnterprisesRepository repository;

  setUp(() => repository = MockWebEnterprisesRepository());

  test('build loads analytics for its period family key', () async {
    final period = DateTime(2026, 8);
    const analytics = <MonthlyAnalyticsEntity>[];
    when(
      () => repository.getAnalytics(period),
    ).thenAnswer((_) async => analytics);
    final container = ProviderContainer(
      overrides: [
        webEnterprisesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    expect(
      await container.read(webAnalyticsControllerProvider(period).future),
      analytics,
    );
    verify(() => repository.getAnalytics(period)).called(1);
  });

  test('refresh reloads analytics for the same period', () async {
    final period = DateTime(2026, 8);
    when(
      () => repository.getAnalytics(period),
    ).thenAnswer((_) async => const <MonthlyAnalyticsEntity>[]);
    final container = ProviderContainer(
      overrides: [
        webEnterprisesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await container.read(webAnalyticsControllerProvider(period).future);

    await container
        .read(webAnalyticsControllerProvider(period).notifier)
        .refresh();

    verify(() => repository.getAnalytics(period)).called(2);
  });
}
