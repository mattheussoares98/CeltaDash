import '../helpers.dart';

enum UIError {
  enterpriseNotFound,
  unexpected,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.enterpriseNotFound:
        return R.string.msgEnterpriseNotFound;
      case UIError.unexpected:
        return R.string.msgUnexpectedError;
    }
  }
}
