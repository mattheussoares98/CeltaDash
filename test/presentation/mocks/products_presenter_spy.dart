import 'package:celta_plus/domain/helpers/helpers.dart';
import 'package:celta_plus/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class ProductsPresenterSpy extends Mock implements ProductsPresenter {
  DateTime lastDateLoadedDataMock = DateTime.now();

  ProductsPresenterSpy() {
    when(() => this.lastDateLoadedData)
        .thenAnswer((_) => lastDateLoadedDataMock);

    _mockLoadProductsCall().thenAnswer((any) async => any);
  }

  When _mockLoadProductsCall() => when(() => this.loadProducts(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ));

  void mockLoadProductsError() {
    _mockLoadProductsCall().thenThrow(DomainError.unexpected);
  }
}
