// test/features/login/data/datasource/firebase_login_enterprise_datasource_test.dart
import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/login/data/datasource/datasource.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';

void main() {
  late MockFirebaseStorage mockFirebaseStorage;
  late FirebaseLoginEnterpriseDatasource datasource;

  final tEnterpriseEntity = EntityFactory.makeFirebaseEnterpriseEntity();
  final tEnterpriseModel = FirebaseEnterpriseModel.fromEntity(tEnterpriseEntity);
  final tEnterpriseName = tEnterpriseEntity.enterpriseName!;
  final tCleanEnterpriseName = tEnterpriseName.trim().toLowerCase().removeWhiteSpaces();
  final tEnterpriseJson = tEnterpriseModel.toJson();
  final tDocId = tEnterpriseEntity.firebaseId!;

  setUp(() {
    mockFirebaseStorage = MockFirebaseStorage();
    datasource = FirebaseLoginEnterpriseDatasource(mockFirebaseStorage);
  });

  test(
    'should return FirebaseEnterpriseModel when firebase document exists',
    () async {
      final fakeDoc = FakeDoc(
        Map<String, dynamic>.from(tEnterpriseJson),
        tDocId,
      );

      when(
        () => mockFirebaseStorage.get(
          path: 'enterprises/$tCleanEnterpriseName',
        ),
      ).thenAnswer((_) async => fakeDoc);

      final result = await datasource.getEnterpriseConfig(
        enterpriseName: tEnterpriseName,
      );

      expect(result.enterpriseName, tEnterpriseName);
      expect(result.baseUrl, tEnterpriseModel.baseUrl);
      expect(result.firebaseId, tDocId);
      expect(
        result.subEnterprises?.length,
        tEnterpriseModel.subEnterprises?.length,
      );

      verify(
        () => mockFirebaseStorage.get(
          path: 'enterprises/$tCleanEnterpriseName',
        ),
      ).called(1);
    },
  );

  test(
    'should throw DomainError.enterpriseNotFound when snapshot data is null',
    () async {
      const fakeDoc = FakeDoc(null, 'some_id');

      when(
        () => mockFirebaseStorage.get(
          path: 'enterprises/$tCleanEnterpriseName',
        ),
      ).thenAnswer((_) async => fakeDoc);

      expect(
        () => datasource.getEnterpriseConfig(enterpriseName: tEnterpriseName),
        throwsA(DomainError.enterpriseNotFound),
      );
    },
  );

  test(
    'should throw DomainError.enterpriseNotFound when storage get throws an exception',
    () async {
      when(
        () => mockFirebaseStorage.get(
          path: 'enterprises/$tCleanEnterpriseName',
        ),
      ).thenThrow(Exception(faker.lorem.sentence()));

      expect(
        () => datasource.getEnterpriseConfig(enterpriseName: tEnterpriseName),
        throwsA(DomainError.enterpriseNotFound),
      );
    },
  );
}
