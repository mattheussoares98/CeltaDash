import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/sales/domain/domain.dart';
import 'package:celta_dash/features/sales/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/sales/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';

class MockSalesRepository extends Mock
    implements ISalesRepository {}

void main() {
  late MockSalesRepository repository;
  late EcParams ecParams;
  late SaleMovementCollectionItemEntity selectedSale;
  late SaleMovementCollectionItemEntity detailedSale;
  late ProviderContainer container;

  setUp(() {
    repository = MockSalesRepository();
    ecParams = EntityFactory.makeEcParams();
    selectedSale = EntityFactory.makeSaleMovementCollectionItemEntity();
    detailedSale = EntityFactory.makeSaleMovementCollectionItemEntity();
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        activeEcParamsStateControllerProvider.overrideWith(
          () => FakeActiveEcParams(ecParams),
        ),
        salesRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('loads every detail for the selected sale', () async {
    final billingDate = selectedSale.dateHourOfBilling!;
    final date = DateTime(billingDate.year, billingDate.month, billingDate.day);
    final params = GetSaleMovementParams(
      documentNumbers: [selectedSale.documentNumber!],
      enterpriseIds: [selectedSale.enterpriseId!],
      startDate: date,
      endDate: date,
      mountCustomer: true,
      mountFiscalNoteType: true,
      mountProducts: true,
      mountSeller: true,
      mountPaymentFinalizations: true,
    );
    final result = EntityFactory.makeSaleMovementEntity(
      collection: [detailedSale],
    );
    when(
      () => repository.getSaleMovements(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => result);

    final value = await container.read(
      saleDetailsControllerProvider(
        selectedSale.enterpriseId!,
        selectedSale.documentNumber!,
        selectedSale.dateHourOfBilling!,
      ).future,
    );

    expect(value, detailedSale);
    verify(
      () => repository.getSaleMovements(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('reports an error when the detailed sale is not found', () async {
    final billingDate = selectedSale.dateHourOfBilling!;
    final date = DateTime(billingDate.year, billingDate.month, billingDate.day);
    final params = GetSaleMovementParams(
      documentNumbers: [selectedSale.documentNumber!],
      enterpriseIds: [selectedSale.enterpriseId!],
      startDate: date,
      endDate: date,
      mountCustomer: true,
      mountFiscalNoteType: true,
      mountProducts: true,
      mountSeller: true,
      mountPaymentFinalizations: true,
    );
    when(
      () => repository.getSaleMovements(params: params, ecParams: ecParams),
    ).thenAnswer(
      (_) async => EntityFactory.makeSaleMovementEntity(collection: []),
    );
    final provider = saleDetailsControllerProvider(
      selectedSale.enterpriseId!,
      selectedSale.documentNumber!,
      selectedSale.dateHourOfBilling!,
    );

    await expectLater(
      container.read(provider.future),
      throwsA(isA<StateError>()),
    );

    expect(container.read(provider).error, isA<StateError>());
  });
}
