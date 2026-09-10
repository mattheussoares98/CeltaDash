import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/buy_movement/data/datasource/datasource.dart';
import 'package:celta_dash/features/buy_movement/data/models/models.dart';
import 'package:celta_dash/features/buy_movement/data/repository/repository.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/features/buy_movement/domain/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

class MockBuyMovementDatasource extends Mock
    implements IBuyMovementDatasource {}

void main() {
  late MockBuyMovementDatasource datasource;
  late IBuyMovementRepository sut;
  late EcParams ecParams;
  late SearchBuyMovementDataParamsEntity params;
  late BuyMovementDataResponseEntity response;

  setUp(() {
    datasource = MockBuyMovementDatasource();
    sut = BuyMovementRepositoryImpl(datasource);
    ecParams = EntityFactory.makeEcParams();
    params = BuyMovementEntityFactory.makeSearchParams();
    response = BuyMovementEntityFactory.makeResponseEntity(
      searchParameters: params,
    );
  });

  group('BuyMovementRepositoryImpl.getData', () {
    test('forwards the exact parameters to the datasource', () async {
      final model = BuyMovementDataResponseModel.fromEntity(response);
      when(
        () => datasource.getData(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => model);

      await sut.getData(params: params, ecParams: ecParams);

      verify(
        () => datasource.getData(params: params, ecParams: ecParams),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('converts the response model results to entities', () async {
      final model = BuyMovementDataResponseModel.fromEntity(response);
      when(
        () => datasource.getData(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => model);

      final result = await sut.getData(params: params, ecParams: ecParams);

      expect(result.results, response.results);
    });

    test('preserves request parameters when the response omits them', () async {
      final model = BuyMovementDataResponseModel.fromEntity(
        BuyMovementDataResponseEntity(results: response.results),
      );
      when(
        () => datasource.getData(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => model);

      final result = await sut.getData(params: params, ecParams: ecParams);

      expect(result.searchParameters, params);
    });

    test(
      'preserves request parameters when the response sanitizes them',
      () async {
        final sanitizedParams = BuyMovementEntityFactory.makeSearchParams(
          enterpriseCodes: const [],
        );
        final model = BuyMovementDataResponseModel.fromEntity(
          BuyMovementDataResponseEntity(
            searchParameters: sanitizedParams,
            results: response.results,
          ),
        );
        when(
          () => datasource.getData(params: params, ecParams: ecParams),
        ).thenAnswer((_) async => model);

        final result = await sut.getData(params: params, ecParams: ecParams);

        expect(result.searchParameters, params);
      },
    );

    test('ignores echoed parameters without a grouping', () async {
      final invalidEcho = SearchBuyMovementDataModel(
        enterpriseCodes: params.enterpriseCodes,
        startDate: params.startDate,
        endDate: params.endDate,
        groupByEnterprise: false,
        groupByProduct: false,
        groupBySupplier: false,
      );
      final model = BuyMovementDataResponseModel(
        searchParameters: invalidEcho,
        results: BuyMovementDataResponseModel.fromEntity(response).results,
      );
      when(
        () => datasource.getData(params: params, ecParams: ecParams),
      ).thenAnswer((_) async => model);

      final result = await sut.getData(params: params, ecParams: ecParams);

      expect(result.searchParameters, params);
      expect(result.results, response.results);
    });

    test('propagates datasource exceptions', () async {
      final exception = Exception('request failed');
      when(
        () => datasource.getData(params: params, ecParams: ecParams),
      ).thenThrow(exception);

      final call = sut.getData(params: params, ecParams: ecParams);

      await expectLater(call, throwsA(same(exception)));
    });
  });
}
