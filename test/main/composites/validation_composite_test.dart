import 'package:celta_dash/main/composites/composites.dart';
import 'package:celta_dash/presentation/protocols/protocols.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../validation/mocks/mocks.dart';

void main() {
  late ValidationComposite sut;
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;

  setUp(() {
    validation1 = FieldValidationSpy();
    validation2 = FieldValidationSpy();
    validation3 = FieldValidationSpy();
    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validations returns null or empty', () {
    final error = sut.validate(null);

    expect(error, null);
  });

  test('Should return the first error', () {
    validation1.mockValidationError(ValidationError.invalidField);
    validation2.mockValidationError(ValidationError.requiredField);
    validation3.mockValidationError(ValidationError.invalidField);

    final error = sut.validate(null);

    expect(error, ValidationError.invalidField);
  });
}
