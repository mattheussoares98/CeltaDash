import 'package:celta_plus/domain/usecases/usecases.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';

// ignore: subtype_of_sealed_class
class DocumentReferenceFake extends Fake
    implements DocumentReference<Map<String, dynamic>> {}

class FirebaseManagerSpy extends Mock implements FirebaseManager {
  FirebaseManagerSpy() {
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
  void mockGet(dynamic value) {
    this._mockGetCall().thenAnswer((any) async => value);
  }

  void mockGetError() {
    this._mockGetCall().thenThrow(Exception());
  }
}
