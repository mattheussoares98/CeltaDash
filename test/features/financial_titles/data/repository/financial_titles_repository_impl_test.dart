// test/features/financial_titles/data/repository/financial_titles_repository_impl_test.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/financial_titles/data/data.dart';
import 'package:celta_dash/features/financial_titles/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';

class MockFinancialTitlesDatasource extends Mock
    implements IFinancialTitlesDatasource {}

void main() {
  late MockFinancialTitlesDatasource mockDatasource;
  late IFinancialTitlesRepository sut;
  late EcParams tEcParams;
  late SearchFinancialTitleDataParams tParams;
  late FinancialTitleDataResponseEntity tEntity;
  late FinancialTitleDataResponseModel tModel;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEcParams());
    registerFallbackValue(
      SearchFinancialTitleDataParams(
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
        enterpriseCodes: const [1],
      ),
    );
  });

  setUp(() {
    mockDatasource = MockFinancialTitlesDatasource();
    sut = FinancialTitlesRepositoryImpl(mockDatasource);
    tEcParams = EntityFactory.makeEcParams();
    tParams = SearchFinancialTitleDataParams(
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 1, 31),
      enterpriseCodes: const [1],
    );

    tEntity = const FinancialTitleDataResponseEntity(
      financialTitlePortions: [
        FinancialTitleDataRowEntity(
          financialTitleCode: 100,
          receiveLiquidValue: 500,
          payLiquidValue: 200,
          liquidBalanceValue: 300,
        ),
      ],
      calculatedTotals: FinancialTitleCalculatedTotalsEntity(
        receiveLiquidValue: 500,
        payLiquidValue: 200,
        liquidBalanceValue: 300,
      ),
    );
    tModel = FinancialTitleDataResponseModel.fromEntity(tEntity);
  });

  group('FinancialTitlesRepositoryImpl.getData', () {
    test('should call datasource with correct params and ecParams', () async {
      when(
        () => mockDatasource.getData(
          params: any(named: 'params'),
          ecParams: any(named: 'ecParams'),
        ),
      ).thenAnswer((_) async => tModel);

      await sut.getData(params: tParams, ecParams: tEcParams);

      verify(
        () => mockDatasource.getData(
          params: tParams,
          ecParams: tEcParams,
        ),
      ).called(1);
    });

    test(
      'should return FinancialTitleDataResponseEntity when datasource returns model',
      () async {
        when(
          () => mockDatasource.getData(
            params: any(named: 'params'),
            ecParams: any(named: 'ecParams'),
          ),
        ).thenAnswer((_) async => tModel);

        final result = await sut.getData(
          params: tParams,
          ecParams: tEcParams,
        );

        expect(result, isA<FinancialTitleDataResponseEntity>());
        expect(
          result.financialTitlePortions.length,
          tEntity.financialTitlePortions.length,
        );
        expect(
          result.financialTitlePortions.first.financialTitleCode,
          tEntity.financialTitlePortions.first.financialTitleCode,
        );
        expect(result.calculatedTotals, tEntity.calculatedTotals);
      },
    );

    test(
      'should propagate error when datasource throws DomainError.unexpected',
      () async {
        when(
          () => mockDatasource.getData(
            params: any(named: 'params'),
            ecParams: any(named: 'ecParams'),
          ),
        ).thenThrow(DomainError.unexpected);

        final call = sut.getData(
          params: tParams,
          ecParams: tEcParams,
        );

        expect(() => call, throwsA(DomainError.unexpected));
      },
    );
  });
}
