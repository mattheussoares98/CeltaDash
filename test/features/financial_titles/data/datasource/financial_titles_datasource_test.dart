// test/features/financial_titles/data/datasource/financial_titles_datasource_test.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/data/http/http.dart';
import 'package:celta_dash/features/financial_titles/data/datasource/datasource.dart';
import 'package:celta_dash/features/financial_titles/data/models/models.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late MockHttpClient mockHttpClient;
  late FinancialTitlesDatasource sut;
  late EcParams tEcParams;
  late SearchFinancialTitleDataParams tParams;
  late FinancialTitleDataResponseEntity tEntity;
  late FinancialTitleDataResponseModel tModel;

  setUp(() {
    mockHttpClient = MockHttpClient();
    sut = FinancialTitlesDatasource(mockHttpClient);
    tEcParams = EntityFactory.makeEcParams();
    tParams = SearchFinancialTitleDataParams(
      startDate: DateTime(2026),
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

  group('FinancialTitlesDatasource.getData', () {
    test(
      'should call httpClient with correct url, method, headers and body',
      () async {
        when(
          () => mockHttpClient.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => <String, dynamic>{});

        await sut.getData(params: tParams, ecParams: tEcParams);

        verify(
          () => mockHttpClient.request(
            url: '${tEcParams.url}/api/FinancialTitles/GetData',
            method: 'post',
            headers: tEcParams.toHeaders(),
            body: tParams.toBody(),
          ),
        ).called(1);
      },
    );

    test(
      'should return FinancialTitleDataResponseModel when request succeeds',
      () async {
        when(
          () => mockHttpClient.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => tModel.toJson());

        final result = await sut.getData(params: tParams, ecParams: tEcParams);

        expect(result, isA<FinancialTitleDataResponseModel>());
        expect(
          result.financialTitlePortions.length,
          tModel.financialTitlePortions.length,
        );
        expect(
          result.financialTitlePortions.first.financialTitleCode,
          tModel.financialTitlePortions.first.financialTitleCode,
        );
      },
    );

    test(
      'should throw HttpError.serverError when httpClient throws HttpError',
      () async {
        when(
          () => mockHttpClient.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenThrow(HttpError.serverError);

        final call = sut.getData(params: tParams, ecParams: tEcParams);

        expect(() => call, throwsA(HttpError.serverError));
      },
    );
  });
}
