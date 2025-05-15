import 'package:celta_plus/domain/helpers/helpers.dart';
import 'package:celta_plus/domain/usecases/usecases.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

// ignore: subtype_of_sealed_class
class DocumentReferenceFake extends Fake
    implements DocumentReference<Map<String, dynamic>> {}

// ignore: must_be_immutable
class MockedFirebaseGet extends Equatable {
  final dynamic dataToReturn;

  MockedFirebaseGet({required this.dataToReturn});

  dynamic data() => dataToReturn;
  String id = faker.guid.guid();

  @override
  List<Object?> get props => [dataToReturn, data(), id];
}

class FirebaseManagerSpy extends Mock implements FirebaseManager {
  final MockedFirebaseGet mockedFirebaseGet;

  FirebaseManagerSpy({required this.mockedFirebaseGet}) {
    registerFallbackValue(DocumentReferenceFake());
    this.mockPut();
  }

  When _mockPutCall() => when(
        () => this.put(
          documentReference: any(named: "documentReference"),
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
          collection: any(named: "collection"),
          doc: any(named: "doc"),
          fieldToSearch: any(named: "fieldToSearch"),
          valueToSearch: any(named: "valueToSearch"),
        ),
      );
  void mockGet(MockedFirebaseGet value) {
    this._mockGetCall().thenAnswer((any) async => value);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(DomainError.unexpected);
  }
}
