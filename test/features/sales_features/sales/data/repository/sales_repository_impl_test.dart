import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/login/domain/entities/entities.dart';
import 'package:celta_dash/features/sales_features/sales/data/datasource/datasource.dart';
import 'package:celta_dash/features/sales_features/sales/data/models/models.dart';
import 'package:celta_dash/features/sales_features/sales/data/repository/repository.dart';
import 'package:celta_dash/features/sales_features/sales/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../domain/mocks/mocks.dart';

class MockSalesDatasource extends Mock implements ISalesDatasource {}

void main() {
  late MockSalesDatasource datasource;
  late SalesRepositoryImpl repository;
  late EcParams ecParams;
  late GetSaleMovementParams params;
  late SaleMovementEntity entity;
  late SaleMovementModel model;

  setUp(() {
    datasource = MockSalesDatasource();
    repository = SalesRepositoryImpl(datasource);
    ecParams = EntityFactory.makeEcParams();
    params = EntityFactory.makeGetSaleMovementParams();
    entity = EntityFactory.makeSaleMovementEntity();
    model = SaleMovementModel.fromEntity(entity);
  });

  test('maps the datasource model to the domain entity', () async {
    when(
      () => datasource.getSaleMovements(params: params, ecParams: ecParams),
    ).thenAnswer((_) async => model);

    final result = await repository.getSaleMovements(
      params: params,
      ecParams: ecParams,
    );

    expect(result, entity);
    verify(
      () => datasource.getSaleMovements(params: params, ecParams: ecParams),
    ).called(1);
  });

  test('propagates datasource failures', () async {
    final exception = Exception('failed to load sale movements');
    when(
      () => datasource.getSaleMovements(params: params, ecParams: ecParams),
    ).thenThrow(exception);

    expect(
      () => repository.getSaleMovements(params: params, ecParams: ecParams),
      throwsA(exception),
    );
  });
}
