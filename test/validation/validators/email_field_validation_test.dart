import 'package:celta_dash/presentation/protocols/protocols.dart';
import 'package:celta_dash/validation/validators/validators.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EmailFieldValidation sut;

  setUp(() {
    sut = const EmailFieldValidation();
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(""), ValidationError.invalidEmail);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidEmail);
  });

  test('Should return error if value is not a email', () {
    expect(
      sut.validate(faker.randomGenerator.string(4, min: 1)),
      ValidationError.invalidEmail,
    );
  });

  test('Should return null if value is equal than min size', () {
    expect(sut.validate(faker.internet.email()), null);
  });
}
