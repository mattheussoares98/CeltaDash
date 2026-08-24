class FakeFirebaseDocument {
  final Map? _data;
  final String id;

  const FakeFirebaseDocument(this._data, this.id);

  Map? data() => _data;
}
