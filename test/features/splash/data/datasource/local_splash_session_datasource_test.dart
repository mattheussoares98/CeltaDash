import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/features/splash/data/data.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  late MockBox box;
  late LocalSplashSessionDatasource datasource;

  setUp(() {
    box = MockBox();
    datasource = LocalSplashSessionDatasource(box);
  });

  group('LocalSplashSessionDatasource - getSavedEnterprise', () {
    test('returns the saved enterprise', () async {
      final entity = EntityFactory.makeFirebaseEnterpriseEntity();
      final json = FirebaseEnterpriseModel.fromEntity(entity).toJson();
      when(
        () => box.get(DatabaseKeys.enterprise.name),
      ).thenAnswer((_) async => json);

      final result = await datasource.getSavedEnterprise();

      expect(result, entity);
      verify(() => box.get(DatabaseKeys.enterprise.name)).called(1);
    });

    test('returns null when no enterprise is saved', () async {
      when(
        () => box.get(DatabaseKeys.enterprise.name),
      ).thenAnswer((_) async => null);

      final result = await datasource.getSavedEnterprise();

      expect(result, isNull);
    });

    test('returns null when the saved value is empty', () async {
      when(
        () => box.get(DatabaseKeys.enterprise.name),
      ).thenAnswer((_) async => '');

      final result = await datasource.getSavedEnterprise();

      expect(result, isNull);
    });

    test('returns null when the saved value is malformed', () async {
      when(
        () => box.get(DatabaseKeys.enterprise.name),
      ).thenAnswer((_) async => 'invalid');

      final result = await datasource.getSavedEnterprise();

      expect(result, isNull);
    });

    test('returns null when Hive throws', () async {
      when(
        () => box.get(DatabaseKeys.enterprise.name),
      ).thenThrow(Exception('hive unavailable'));

      final result = await datasource.getSavedEnterprise();

      expect(result, isNull);
    });
  });
}
