class FakeFirebaseDocument {
  final dynamic _data;
  final String id;

  const FakeFirebaseDocument(this._data, this.id);

  dynamic data() => _data;
}
