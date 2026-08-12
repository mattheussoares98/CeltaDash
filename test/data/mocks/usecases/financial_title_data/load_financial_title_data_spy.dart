import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadFinancialTitleDataSpy extends Mock implements LoadFinancialTitleData {
  When<Future<FinancialTitleDataResponseEntity>> _mockGetCall() => when(
        () => get(any()),
      );

  void mockGet(FinancialTitleDataResponseEntity response) {
    _mockGetCall().thenAnswer((_) async => response);
  }

  void mockGetWith(
    Future<FinancialTitleDataResponseEntity> Function(
      SearchFinancialTitleDataParams params,
    ) callback,
  ) {
    _mockGetCall().thenAnswer(
      (invocation) => callback(
        invocation.positionalArguments.first as SearchFinancialTitleDataParams,
      ),
    );
  }

  void mockGetError() {
    _mockGetCall().thenThrow(DomainError.unexpected);
  }

  void verifyGet(SearchFinancialTitleDataParams params, int count) {
    verify(() => get(params)).called(count);
  }
}
