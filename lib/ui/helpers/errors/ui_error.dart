import '../helpers.dart';

enum UIError {
  enterpriseAlreadyExists,
  enterpriseNotFound,
  sameDays,
  sameUrl,
  unexpected,
  updateCeltaBs,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.enterpriseAlreadyExists:
        return R.string.msgEnterpriseAlreadyExists;
      case UIError.enterpriseNotFound:
        return R.string.msgEnterpriseNotFound;
      case UIError.sameDays:
        return R.string.msgCantCompareSameDays;
      case UIError.sameUrl:
        return R.string.msgSameUrl;
      case UIError.unexpected:
        return R.string.msgUnexpectedError;
      case UIError.updateCeltaBs:
        return R.string.msgUpdateCeltaBs;
    }
  }
}
