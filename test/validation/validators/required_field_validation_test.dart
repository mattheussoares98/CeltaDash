import 'package:celta_plus/presentation/protocols/protocols.dart';
import 'package:celta_plus/validation/validators/validators.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = const RequiredFieldValidation();
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate(faker.randomGenerator.string(10)), null);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(""), ValidationError.requiredField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(""), ValidationError.requiredField);
    expect(sut.validate(null), ValidationError.requiredField);
  });
}
