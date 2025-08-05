import 'package:celta_dash/presentation/protocols/protocols.dart';
import 'package:celta_dash/validation/validators/validators.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  NumberFieldValidation sut;

  group("Int validation", () {
    test('Should return error if value is String', () {
      sut = const NumberFieldValidation(onlyInt: true);

      expect(sut.validate(faker.randomGenerator.string(50)),
          ValidationError.invalidNumber);
    });
    test('Should return error if value is decimal', () {
      sut = const NumberFieldValidation(onlyInt: true);

      expect(sut.validate(faker.randomGenerator.decimal().toString()),
          ValidationError.invalidNumber);
    });

    test('Should return null if value is null or empty', () {
      sut = const NumberFieldValidation(onlyInt: true);

      expect(sut.validate(""), null);
      expect(sut.validate(null), null);
    });

    test('Should return null if value is int', () {
      sut = const NumberFieldValidation(onlyInt: true);

      expect(sut.validate(faker.randomGenerator.integer(100).toString()), null);
    });
  });
  group("Decimal validation", () {
    test('Should return error if value is String', () {
      sut = const NumberFieldValidation(onlyInt: false);

      expect(sut.validate(faker.randomGenerator.string(10)),
          ValidationError.invalidNumber);
    });
    test('Should return null if value is decimal', () {
      sut = const NumberFieldValidation(onlyInt: false);

      expect(sut.validate(faker.randomGenerator.decimal().toString()), null);
    });

    test('Should return null if value is null or empty', () {
      sut = const NumberFieldValidation(onlyInt: false);

      expect(sut.validate(""), null);
      expect(sut.validate(null), null);
    });

    test('Should return null if value is int', () {
      sut = const NumberFieldValidation(onlyInt: false);

      expect(sut.validate(faker.randomGenerator.integer(100).toString()), null);
    });
  });
}
