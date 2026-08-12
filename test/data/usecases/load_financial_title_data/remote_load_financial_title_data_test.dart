import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/data/usecases/usecases.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/main/builders/builders.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';

void main() {
  late RemoteLoadFinancialTitleData sut;
  late HttpClientSpy httpClient;
  late SearchFinancialTitleDataParams params;
  late FinancialTitleDataResponseEntity responseEntity;

  setUp(() {
    httpClient = HttpClientSpy();
    sut = RemoteLoadFinancialTitleData(httpClient);
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    params = EntityFactory.makeSearchFinancialTitleDataParams();
    responseEntity = EntityFactory.makeFinancialTitleDataResponseEntity(
      searchParameters: params,
    );
    httpClient.mockRequest(
      FinancialTitleDataResponseModel.fromEntity(responseEntity).toJson(),
    );
  });

  test('Should call httpClient with correct parameters', () async {
    await sut.get(params);

    verify(
      () => httpClient.request(
        url:
            '${EnterpriseBuilder.entity!.baseUrl!}/api/FinancialTitles/GetData',
        method: 'post',
        headers: {
          'user': EnterpriseBuilder.entity?.bsUser?.name,
          'accessKey': EnterpriseBuilder.entity?.bsUser?.AccessKey,
        },
        body: SearchFinancialTitleDataModel.fromEntity(params).toJson(),
      ),
    ).called(1);
  });

  test('Should return the entity converted by its model', () async {
    final result = await sut.get(params);

    expect(result, responseEntity);
  });

  test('Should use explicitly provided connection parameters', () async {
    final url = faker.internet.httpUrl();
    final userName = faker.internet.userName();
    final accessKey = faker.guid.guid();

    await sut.get(
      params,
      url: url,
      userName: userName,
      accessKey: accessKey,
    );

    verify(
      () => httpClient.request(
        url: '$url/api/FinancialTitles/GetData',
        method: 'post',
        headers: {
          'user': userName,
          'accessKey': accessKey,
        },
        body: SearchFinancialTitleDataModel.fromEntity(params).toJson(),
      ),
    ).called(1);
  });
}
