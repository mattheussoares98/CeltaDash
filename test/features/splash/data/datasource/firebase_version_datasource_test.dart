import 'package:celta_dash/features/splash/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/mocks/mocks.dart';

class FakeInvalidDocument {
  Object data() => 'invalid';
}

void main() {
  late MockFirebaseStorage firebaseStorage;
  late FirebaseVersionDatasource datasource;

  setUp(() {
    firebaseStorage = MockFirebaseStorage();
    datasource = FirebaseVersionDatasource(firebaseStorage);
  });

  group('FirebaseVersionDatasource - getRequiredVersion', () {
    test('returns required version from Firebase', () async {
      const version = '1.2.3';
      const document = FakeDoc({'required': version}, 'version');
      when(
        () => firebaseStorage.get(path: 'requiredVersion/version'),
      ).thenAnswer((_) async => document);

      final result = await datasource.getRequiredVersion();

      expect(result, version);
      verify(
        () => firebaseStorage.get(path: 'requiredVersion/version'),
      ).called(1);
    });

    test('returns null when the document does not exist', () async {
      when(
        () => firebaseStorage.get(path: 'requiredVersion/version'),
      ).thenAnswer((_) async => null);

      final result = await datasource.getRequiredVersion();

      expect(result, isNull);
    });

    test('returns null when document data is not a map', () async {
      final document = FakeInvalidDocument();
      when(
        () => firebaseStorage.get(path: 'requiredVersion/version'),
      ).thenAnswer((_) async => document);

      final result = await datasource.getRequiredVersion();

      expect(result, isNull);
    });

    test('returns null when Firebase throws', () async {
      when(
        () => firebaseStorage.get(path: 'requiredVersion/version'),
      ).thenThrow(Exception('firebase unavailable'));

      final result = await datasource.getRequiredVersion();

      expect(result, isNull);
    });
  });
}
