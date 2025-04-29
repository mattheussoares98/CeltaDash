import 'package:celta_plus/data/models/models.dart';
import 'package:celta_plus/data/usecases/usecases.dart';
import 'package:celta_plus/domain/entities/entities.dart';
import 'package:celta_plus/main/builders/builders.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';

void main() {
  late RemoteLoadEnterprises sut;

  late HttpClientSpy httpClient;

  late List<EnterpriseEntity> enterprises;

  WidgetsFlutterBinding.ensureInitialized();

  void initUsecases() {
    httpClient = HttpClientSpy();
  }

  void initPresenters() {
    sut = RemoteLoadEnterprises(httpClient);
  }

  void initEntities() {
    EnterpriseBuilder.entity = EntityFactory.makeFirebaseEnterpriseEntity();
    enterprises = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ];
  }

  void initMockSuccess() {
    final results =
        enterprises.map((e) => EnterpriseModel.fromEntity(e).toJson()).toList();

    httpClient.mockRequest(
      results.map((e) => EnterpriseModel.fromJson(e).toJson()).toList(),
    );
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntities();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue("");
  });

  test("Should call httpClient with correct parameters", () async {
    await sut.get();

    verify(
      () => httpClient.request(
        url: "${EnterpriseBuilder.entity!.baseUrl!}/api/enterprises",
        method: "get",
        headers: {
          "user": EnterpriseBuilder.entity?.bsUser?.name,
          "accessKey": EnterpriseBuilder.entity?.bsUser?.AccessKey,
        },
      ),
    ).called(1);
  });

  test(
    "Should return correct value",
    () async {
      final list = await sut.get();

      expect(list, enterprises);
    },
  );
}
