import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/canceled_sales/domain/domain.dart';
import 'package:celta_dash/features/canceled_sales/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/canceled_sales/presentation/models/models.dart';
import 'package:celta_dash/features/canceled_sales/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';
import '../../../home/mocks/mocks.dart';

class MockCanceledSalesRepository extends Mock
    implements ICanceledSalesRepository {}

void main() {
  late MockCanceledSalesRepository repository;
  late EcParams ecParams;
  late SaleMovementEntity result;
  late ProviderContainer container;
  final selectedDate = DateTime(2026, 8, 20);
  const enterpriseId = 10;

  GetSaleMovementParams makeParams(CanceledSalesPeriod period) =>
      GetSaleMovementParams(
        enterpriseIds: const [enterpriseId],
        startDate: period == CanceledSalesPeriod.daily
            ? DateTime(2026, 8, 20)
            : DateTime(2026, 8),
        endDate: period == CanceledSalesPeriod.daily
            ? DateTime(2026, 8, 20)
            : DateTime(2026, 8, 31),
        onlyCancelled: true,
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
      canceledSalesRepositoryProvider.overrideWithValue(repository),
    ],
  );

  setUp(() {
    repository = MockCanceledSalesRepository();
    ecParams = EntityFactory.makeEcParams();
    result = EntityFactory.makeSaleMovementEntity();
    container = makeContainer();
  });

  tearDown(() => container.dispose());

  for (final period in CanceledSalesPeriod.values) {
    test('loads canceled sales for the ${period.name} period', () async {
      final params = makeParams(period);
      when(
        () => repository.getSaleMovements(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => result);

      final value = await container.read(
        canceledSalesControllerProvider(enterpriseId, period).future,
      );

      expect(value, result);
      verify(
        () => repository.getSaleMovements(params: params, ecParams: ecParams),
      ).called(1);
    });
  }

  test('preserves repository errors in the controller state', () async {
    final params = makeParams(CanceledSalesPeriod.daily);
    final exception = Exception('failed to load canceled sales');
    when(
      () => repository.getSaleMovements(params: params, ecParams: ecParams),
    ).thenThrow(exception);
    final provider = canceledSalesControllerProvider(
      enterpriseId,
      CanceledSalesPeriod.daily,
    );

    await expectLater(container.read(provider.future), throwsA(exception));

    expect(container.read(provider).error, same(exception));
    expect(container.read(provider).stackTrace, isNotNull);
  });
}
