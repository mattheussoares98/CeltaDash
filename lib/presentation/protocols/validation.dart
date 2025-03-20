import '../../ui/helpers/helpers.dart';

abstract class Validation {
  ValidationError? validate(String? value);
}

enum ValidationError {
  invalidEmail,
  invalidField,
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
      case ValidationError.requiredField:
        return R.string.msgRequiredField;
      case ValidationError.shortField:
        return R.string.msgVeryShortField;
    }
  }
}
