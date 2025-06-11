import '../helpers.dart';

class UIError {
  final String description;
  const UIError._(this.description);
  @override
  String toString() => description;

  factory UIError.custom(String description) => UIError._(description);

  static final disabledEnterprise = UIError._(R.string.msgDisabledEnterprise);
  static final enterpriseAlreadyExists =
      UIError._(R.string.msgEnterpriseAlreadyExists);
  static final enterpriseNotFound = UIError._(R.string.msgEnterpriseNotFound);
  static final sameDays = UIError._(R.string.msgCantCompareSameDays);
  static final sameUrl = UIError._(R.string.msgSameUrl);
  static final unexpected = UIError._(R.string.msgUnexpectedError);
  static final updateCeltaBs = UIError._(R.string.msgUpdateCeltaBs);
}
