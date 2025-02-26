import '../helpers.dart';

enum UIError { unexpected }

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.unexpected:
        return R.string.msgUnexpectedError;
    }
  }
}
