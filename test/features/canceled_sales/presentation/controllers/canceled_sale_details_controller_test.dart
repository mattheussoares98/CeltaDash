import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/canceled_sales/domain/domain.dart';
import 'package:celta_dash/features/canceled_sales/presentation/controllers/controllers.dart';
import 'package:celta_dash/features/canceled_sales/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';

class MockCanceledSalesRepository extends Mock
    implements ICanceledSalesRepository {}

void main() {
  late MockCanceledSalesRepository repository;
  late EcParams ecParams;
  late SaleMovementCollectionItemEntity selectedSale;
  late SaleMovementCollectionItemEntity detailedSale;
  late ProviderContainer container;

  setUp(() {
    repository = MockCanceledSalesRepository();
    ecParams = EntityFactory.makeEcParams();
    selectedSale = EntityFactory.makeSaleMovementCollectionItemEntity();
    detailedSale = EntityFactory.makeSaleMovementCollectionItemEntity();
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        activeEcParamsStateControllerProvider.overrideWith(
          () => FakeActiveEcParams(ecParams),
        ),
        canceledSalesRepositoryProvider.overrideWithValue(repository),
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
      canceledSaleDetailsControllerProvider(
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
    final provider = canceledSaleDetailsControllerProvider(
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
