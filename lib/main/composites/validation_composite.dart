import '../../presentation/protocols/protocols.dart';
import '../../validation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError? validate(String? value) {
    ValidationError? error;
    for (final validation in validations) {
      error = validation.validate(value);
      if (error != null) {
        return error;
      }
    }
    return error;
  }
}
