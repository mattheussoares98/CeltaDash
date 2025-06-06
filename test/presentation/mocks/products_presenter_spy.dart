import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class ProductsPresenterSpy extends Mock implements ProductsPresenter {
  GetSalesParams? lastGetSalesParamsMock;

  ProductsPresenterSpy() {
    when(() => this.lastGetSalesParams)
        .thenAnswer((_) => lastGetSalesParamsMock);

    _mockLoadProductsCall().thenAnswer((any) async => any);
  }

  When _mockLoadProductsCall() => when(() => this.getSales(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
        periodType: any(named: 'periodType'),
      ));

  void mockLoadProductsError() {
    _mockLoadProductsCall().thenThrow(DomainError.unexpected);
  }
}
