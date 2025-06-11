class BsError implements Exception {
  final String message;
  BsError(this.message);

  @override
  String toString() => message;
}
