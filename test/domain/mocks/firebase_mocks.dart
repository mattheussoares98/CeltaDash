// test/domain/mocks/firebase_mocks.dart
import 'package:celta_dash/data/database/database.dart';
import 'package:mocktail/mocktail.dart';

class FakeDoc {
  final Map<String, dynamic>? _json;
  final String? id;

  const FakeDoc(this._json, this.id);

  Map<String, dynamic>? data() => _json;
}

class MockedFirebaseGet {
  final List<FakeDoc>? dataToReturn;
  late final List<FakeDoc> docs;

  MockedFirebaseGet({required this.dataToReturn}) {
    docs = dataToReturn ?? [];
  }

  Map<String, dynamic>? data() {
    if (dataToReturn == null || dataToReturn!.isEmpty) return null;
    return dataToReturn!.first.data();
  }

  String? get id {
    if (dataToReturn == null || dataToReturn!.isEmpty) return null;
    return dataToReturn!.first.id;
  }
}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}
