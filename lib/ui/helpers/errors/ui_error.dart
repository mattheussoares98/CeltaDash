import 'package:equatable/equatable.dart';

import '../helpers.dart';

class UIError extends Equatable {
  final String description;
  const UIError._(this.description);
  @override
  String toString() => description;
  @override
  List<Object?> get props => [description];

  factory UIError.custom(String description) => UIError._(description);

  static final cannotRemoveSelectedEnterprise =
      UIError._(R.string.msgCannotRemoveSelectedEnterprise);
  static final disabledEnterprise = UIError._(R.string.msgDisabledEnterprise);
  static final enterpriseAlreadyExists =
      UIError._(R.string.msgEnterpriseAlreadyExists);
  static final enterpriseNotFound = UIError._(R.string.msgEnterpriseNotFound);
  static final sameDays = UIError._(R.string.msgCantCompareSameDays);
  static final sameUrl = UIError._(R.string.msgSameUrl);
  static final selectPeriod = UIError._(R.string.msgSelectPeriod);
  static final unexpected = UIError._(R.string.msgUnexpectedError);
  static final updateCeltaBs = UIError._(R.string.msgUpdateCeltaBs);
}
