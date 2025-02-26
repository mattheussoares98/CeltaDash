import '../../ui/helpers/helpers.dart';

abstract class Validation {
  ValidationError? validate({required String field, required Map input});
}

enum ValidationError {
  invalidField,
  requiredField,
  shortField,
}

extension ValidationErrorExtension on ValidationError {
  String get description {
    switch (this) {
      case ValidationError.invalidField:
        return R.string.msgInvalidField;
      case ValidationError.requiredField:
        return R.string.msgRequiredField;
      case ValidationError.shortField:
        return R.string.msgVeryShortField;
    }
  }
}
