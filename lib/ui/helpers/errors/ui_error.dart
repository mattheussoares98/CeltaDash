import '../helpers.dart';

enum UIError {
  enterpriseNotFound,
  sameDays,
  unexpected,
  updateCeltaBs,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.enterpriseNotFound:
        return R.string.msgEnterpriseNotFound;
      case UIError.sameDays:
        return R.string.msgCantCompareSameDays;
      case UIError.unexpected:
        return R.string.msgUnexpectedError;
      case UIError.updateCeltaBs:
        return R.string.msgUpdateCeltaBs;
    }
  }
}
