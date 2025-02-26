

import 'package:celta_plus/presentation/protocols/protocols.dart';

import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {
  ValidationSpy() {
    this.mockValidation();
  }

  When mockValidationCall(String? field) => when(
        () => this.validate(
          field: field ?? any(named: 'field'),
          input: any(named: 'input'),
        ),
      );
  void mockValidation({String? field}) =>
      this.mockValidationCall(field).thenReturn(null);
  void mockValidationError({String? field, required ValidationError value}) =>
      this.mockValidationCall(field).thenReturn(value);
}
