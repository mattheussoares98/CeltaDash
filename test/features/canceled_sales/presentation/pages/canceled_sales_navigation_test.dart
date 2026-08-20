import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/canceled_sales/domain/domain.dart';
import 'package:celta_dash/features/canceled_sales/presentation/pages/components/components.dart';
import 'package:celta_dash/features/canceled_sales/providers.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../../../presentation/fake_controllers/fake_controllers.dart';

class MockCanceledSalesRepository extends Mock
    implements ICanceledSalesRepository {}

void main() {
  testWidgets('tapping a row opens and loads the sale details', (tester) async {
    final repository = MockCanceledSalesRepository();
    final ecParams = EntityFactory.makeEcParams();
    final selectedSale = EntityFactory.makeSaleMovementCollectionItemEntity();
    final detailedSale = EntityFactory.makeSaleMovementCollectionItemEntity();
    final billingDate = selectedSale.dateHourOfBilling!;
    final params = GetSaleMovementParams(
      documentNumbers: [selectedSale.documentNumber!],
      enterpriseIds: [selectedSale.enterpriseId!],
      startDate: DateTime(billingDate.year, billingDate.month, billingDate.day),
      endDate: DateTime(billingDate.year, billingDate.month, billingDate.day),
      mountCustomer: true,
      mountFiscalNoteType: true,
      mountProducts: true,
      mountSeller: true,
      mountPaymentFinalizations: true,
    );
    when(
      () => repository.getSaleMovements(params: params, ecParams: ecParams),
    ).thenAnswer(
      (_) async =>
          EntityFactory.makeSaleMovementEntity(collection: [detailedSale]),
    );
    final router = GoRouter(
      initialLocation: '/list',
      routes: [
        GoRoute(
          path: '/list',
          builder: (context, state) => Scaffold(
            body: CanceledSalesTable(
              sales: [selectedSale],
              refreshProvider: null,
            ),
          ),
        ),
        canceledSaleDetailsRoute(),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeEcParamsStateControllerProvider.overrideWith(
            () => FakeActiveEcParams(ecParams),
          ),
          canceledSalesRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text(selectedSale.documentNumber!).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      router.state.uri.path,
      '/home/bs-sale-details/${selectedSale.enterpriseId}'
      '/${selectedSale.documentNumber}'
      '/${selectedSale.dateHourOfBilling!.millisecondsSinceEpoch}',
    );
    expect(find.text('Detalhes'), findsOneWidget);
    verify(
      () => repository.getSaleMovements(params: params, ecParams: ecParams),
    ).called(1);
  });
}
