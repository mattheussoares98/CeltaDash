import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:celta_dash/features/sales/domain/domain.dart';
import 'package:celta_dash/features/sales/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sales/presentation/models/models.dart';
import 'package:celta_dash/features/sales/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../../home/mocks/mocks.dart';

class MockSalesRepository extends Mock implements ISalesRepository {}

void main() {
  late MockSalesRepository repository;
  late EcParams ecParams;
  late SaleMovementEntity result;
  late ProviderContainer container;
  final selectedDate = DateTime(2026, 8, 20);
  const enterpriseId = 10;

  GetSaleMovementParams makeParams(
    SalesPeriod period, {
    required bool onlyCancelled,
    int actualPage = 1,
  }) => GetSaleMovementParams(
    enterpriseIds: const [enterpriseId],
    startDate: period == SalesPeriod.daily
        ? DateTime(2026, 8, 20)
        : DateTime(2026, 8),
    endDate: period == SalesPeriod.daily
        ? DateTime(2026, 8, 20)
        : DateTime(2026, 8, 31),
    onlyCancelled: onlyCancelled,
    onlyNotCancelled: !onlyCancelled,
    actualPage: actualPage,
  );

  ProviderContainer makeContainer() => ProviderContainer(
    retry: (_, _) => null,
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
      salesRepositoryProvider.overrideWithValue(repository),
    ],
  );

  setUp(() {
    repository = MockSalesRepository();
    ecParams = EntityFactory.makeEcParams();
    result = EntityFactory.makeSaleMovementEntity();
    container = makeContainer();
  });

  tearDown(() => container.dispose());

  for (final onlyCancelled in [true, false]) {
    for (final period in SalesPeriod.values) {
      test('loads ${onlyCancelled ? 'canceled' : 'non-canceled'} sales for the '
          '${period.name} period', () async {
        final params = makeParams(period, onlyCancelled: onlyCancelled);
        when(
          () => repository.getSaleMovements(params: params, ecParams: ecParams),
        ).thenAnswer((_) async => result);

        final value = await container.read(
          salesControllerProvider(
            enterpriseId,
            period,
            onlyCancelled,
            1,
          ).future,
        );

        expect(value, result);
        verify(
          () => repository.getSaleMovements(params: params, ecParams: ecParams),
        ).called(1);
      });
    }
  }

  test('passes the selected page to the repository', () async {
    final params = makeParams(
      SalesPeriod.daily,
      onlyCancelled: false,
      actualPage: 2,
    );
    when(
      () => repository.getSaleMovements(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => result);

    await container.read(
      salesControllerProvider(enterpriseId, SalesPeriod.daily, false, 2).future,
    );

    verify(
      () => repository.getSaleMovements(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('preserves repository errors in the controller state', () async {
    final params = makeParams(SalesPeriod.daily, onlyCancelled: true);
    final exception = Exception('failed to load canceled sales');
    when(
      () => repository.getSaleMovements(params: params, ecParams: ecParams),
    ).thenThrow(exception);
    final provider = salesControllerProvider(
      enterpriseId,
      SalesPeriod.daily,
      true,
      1,
    );

    await expectLater(container.read(provider.future), throwsA(exception));

    expect(container.read(provider).error, same(exception));
    expect(container.read(provider).stackTrace, isNotNull);
  });
}
