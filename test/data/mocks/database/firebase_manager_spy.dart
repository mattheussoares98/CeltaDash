import 'package:celta_dash/domain/usecases/usecases.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

// ignore: unused_element
class FakeDoc {
  final Map<String, dynamic>? _json;
  final String? id;
  Map<String, dynamic>? data() => _json;
  FakeDoc(this._json, this.id);
}

// ignore: subtype_of_sealed_class
class DocumentReferenceFake extends Fake
    implements DocumentReference<Map<String, dynamic>> {
  @override
  final String id = faker.guid.guid();
}

// ignore: must_be_immutable
class MockedFirebaseGet extends Equatable {
  final List<FakeDoc>? dataToReturn;
  late final List<FakeDoc> docs;

  MockedFirebaseGet({required this.dataToReturn}) {
    docs = dataToReturn?.map((d) => FakeDoc(d._json, d.id)).toList() ?? [];
  }

  Map<String, dynamic>? data() {
    if (dataToReturn == null || dataToReturn!.isEmpty) return null;
    return dataToReturn!.first.data();
  }

  /// for login path if you read the document ID
  String? get id {
    if (dataToReturn == null || dataToReturn!.isEmpty) return null;
    return dataToReturn!.first.id;
  }

  @override
  List<Object?> get props => [dataToReturn, docs, data(), id];
}

class FirebaseManagerSpy extends Mock implements FirebaseManager {
  final MockedFirebaseGet mockedFirebaseGet;

  FirebaseManagerSpy({required this.mockedFirebaseGet}) {
    registerFallbackValue(DocumentReferenceFake());
    this.mockPut();
    this.mockGet(mockedFirebaseGet);
  }

  When _mockPutCall() => when(
    () => this.put(
      path: any(named: "path"),
      data: any(named: "data"),
      arrayUnion: any(named: "arrayUnion"),
      increment: any(named: "increment"),
      merge: any(named: "merge"),
    ),
  );
  void mockPut() {
    this._mockPutCall().thenAnswer((any) async => any);
  }

  void mockPutError() {
    this._mockPutCall().thenThrow(Exception());
  }

  When _mockGetCall() => when(
    () => this.get(
      path: any(named: "path"),
      fieldToSearch: any(named: "fieldToSearch"),
      valueToSearch: any(named: "valueToSearch"),
    ),
  );
  void mockGet(MockedFirebaseGet value) {
    this._mockGetCall().thenAnswer((any) async => value);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(Exception());
  }
}
