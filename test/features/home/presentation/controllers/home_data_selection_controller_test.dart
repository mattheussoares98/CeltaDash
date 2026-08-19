import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mocks.dart';

void main() {
  test(
    'exposes only the selection for the requested active app mode',
    () async {
      final selectedDate = DateTime(2026, 8, 19);
      final homeController = FakeHomeController(
        HomeState.initial(
          appMode: AppMode.sales,
        ).copyWith(selectedEnterpriseId: 10, selectedDate: selectedDate),
      );
      final container = ProviderContainer(
        overrides: [homeControllerProvider.overrideWith(() => homeController)],
      );
      addTearDown(container.dispose);

      await container.read(homeControllerProvider.future);

      expect(
        await container.read(
          homeDataSelectionControllerProvider(AppMode.sales).future,
        ),
        HomeDataSelectionState(
          appMode: AppMode.sales,
          enterpriseId: 10,
          selectedDate: selectedDate,
        ),
      );
      expect(
        await container.read(
          homeDataSelectionControllerProvider(AppMode.financialTitles).future,
        ),
        isNull,
      );
    },
  );

  test('notifies only while its app mode is active', () async {
    final initialDate = DateTime(2026, 8, 19);
    final homeController = FakeHomeController(
      HomeState.initial(
        appMode: AppMode.sales,
      ).copyWith(selectedEnterpriseId: 10, selectedDate: initialDate),
    );
    final container = ProviderContainer(
      overrides: [homeControllerProvider.overrideWith(() => homeController)],
    );
    addTearDown(container.dispose);
    await container.read(homeControllerProvider.future);

    final provider = homeDataSelectionControllerProvider(AppMode.sales);
    await container.read(provider.future);
    final values = <HomeDataSelectionState?>[];
    final subscription = container.listen(provider, (_, next) {
      if (next.hasValue && !next.isLoading) values.add(next.value);
    }, fireImmediately: true);
    addTearDown(subscription.close);

    homeController.updateState(
      homeController.homeState.copyWith(
        selectedDate: initialDate.add(const Duration(days: 1)),
      ),
    );
    await pumpEventQueue();
    homeController.updateState(
      homeController.homeState.copyWith(
        appMode: AppMode.financialTitles,
        selectedDate: initialDate.add(const Duration(days: 2)),
      ),
    );
    await pumpEventQueue();
    homeController.updateState(
      homeController.homeState.copyWith(
        appMode: AppMode.financialTitles,
        selectedDate: initialDate.add(const Duration(days: 3)),
      ),
    );
    await pumpEventQueue();

    expect(values, hasLength(3));
    expect(values[0]?.selectedDate, initialDate);
    expect(values[1]?.selectedDate, initialDate.add(const Duration(days: 1)));
    expect(values[2], isNull);
  });
}
