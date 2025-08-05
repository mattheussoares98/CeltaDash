import '../../ui/helpers/helpers.dart';

abstract class Validation {
  ValidationError? validate(String? value);
}

enum ValidationError {
  invalidEmail,
  invalidField,
  invalidNumber,
  invalidUrl,
  requiredField,
  shortField,
}

extension ValidationErrorExtension on ValidationError {
  String get description {
    switch (this) {
      case ValidationError.invalidEmail:
        return R.string.msgInvalidEmail;
      case ValidationError.invalidField:
        return R.string.msgInvalidField;
      case ValidationError.invalidUrl:
        return R.string.msgInvalidUrl;
      case ValidationError.invalidNumber:
        return R.string.msgInvalidNumber;
      case ValidationError.requiredField:
        return R.string.msgRequiredField;
      case ValidationError.shortField:
        return R.string.msgVeryShortField;
    }
  }
}
