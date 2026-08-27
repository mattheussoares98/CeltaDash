// test/features/sale_statistics/data/repository/sale_statistics_repository_impl_test.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/data/data.dart';
import 'package:celta_dash/features/sales_features/sale_statistics/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../domain/mocks/mocks.dart';

class MockSaleStatisticsDatasource extends Mock
    implements ISaleStatisticsDatasource {}

void main() {
  late MockSaleStatisticsDatasource mockDatasource;
  late ISaleStatisticsRepository sut;
  late EcParams tEcParams;
  late GetSaleStatisticsParams tParams;
  late SaleStatisticsEntity tEntity;
  late SaleStatisticsModel tModel;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEcParams());
    registerFallbackValue(EntityFactory.makeGetSalesParams());
  });

  setUp(() {
    mockDatasource = MockSaleStatisticsDatasource();
    sut = SaleStatisticsRepositoryImpl(mockDatasource);
    tEcParams = EntityFactory.makeEcParams();
    tParams = EntityFactory.makeGetSalesParams();
    tEntity = EntityFactory.makeSaleStatisticEntity();
    tModel = SaleStatisticsModel.fromEntity(tEntity);
  });

  group('SaleStatisticsRepositoryImpl.getSaleStatistics', () {
    test('should call datasource with correct params and ecParams', () async {
      when(
        () => mockDatasource.getSaleStatistics(
          params: any(named: 'params'),
          ecParams: any(named: 'ecParams'),
        ),
      ).thenAnswer((_) async => [tModel]);

      await sut.getSaleStatistics(params: tParams, ecParams: tEcParams);

      verify(
        () => mockDatasource.getSaleStatistics(
          params: tParams,
          ecParams: tEcParams,
        ),
      ).called(1);
    });

    test(
      'should return list of SaleStatisticsEntity when datasource returns models',
      () async {
        when(
          () => mockDatasource.getSaleStatistics(
            params: any(named: 'params'),
            ecParams: any(named: 'ecParams'),
          ),
        ).thenAnswer((_) async => [tModel]);

        final result = await sut.getSaleStatistics(
          params: tParams,
          ecParams: tEcParams,
        );

        expect(result, isA<List<SaleStatisticsEntity>>());
        expect(result.length, 1);
        expect(result.first, tEntity);
      },
    );

    test('should propagate error when datasource throws Exception()', () async {
      when(
        () => mockDatasource.getSaleStatistics(
          params: any(named: 'params'),
          ecParams: any(named: 'ecParams'),
        ),
      ).thenThrow(Exception());

      final call = sut.getSaleStatistics(params: tParams, ecParams: tEcParams);

      expect(() => call, throwsA(Exception()));
    });
  });
}
