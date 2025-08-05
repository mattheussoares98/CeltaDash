import 'package:celta_dash/presentation/protocols/protocols.dart';
import 'package:celta_dash/validation/validators/validators.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late NumberFieldValidation sut;

  group("Int validation", () {
    sut = const NumberFieldValidation(onlyInt: true);
    test('Should return error if value is String', () {
      expect(sut.validate(faker.randomGenerator.string(10)),
          ValidationError.invalidNumber);
    });
    test('Should return error if value is decimal', () {
      expect(sut.validate(faker.randomGenerator.decimal().toString()),
          ValidationError.invalidNumber);
    });

    test('Should return null if value is null or empty', () {
      expect(sut.validate(""), null);
      expect(sut.validate(null), null);
    });

    test('Should return null if value is int', () {
      expect(sut.validate(faker.randomGenerator.integer(100).toString()), null);
    });
  });
  group("Decimal validation", () {
    sut = const NumberFieldValidation(onlyInt: false);
    test('Should return error if value is String', () {
      expect(sut.validate(faker.randomGenerator.string(10)),
          ValidationError.invalidNumber);
    });
    test('Should return null if value is decimal', () {
      expect(sut.validate(faker.randomGenerator.decimal().toString()), null);
    });

    test('Should return null if value is null or empty', () {
      expect(sut.validate(""), null);
      expect(sut.validate(null), null);
    });

    test('Should return null if value is int', () {
      expect(sut.validate(faker.randomGenerator.integer(100).toString()), null);
    });
  });
}
