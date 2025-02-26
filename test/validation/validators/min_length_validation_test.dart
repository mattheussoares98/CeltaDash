import 'package:celta_plus/presentation/protocols/protocols.dart';
import 'package:celta_plus/validation/validators/validators.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = const MinLengthValidation(field: 'any_field', size: 5);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate({'any_field': ''}), ValidationError.shortField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate({}), ValidationError.shortField);
    expect(sut.validate({'any_field': null}), ValidationError.shortField);
  });

  test('Should return error if value is less than min size', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(4, min: 1)}),
        ValidationError.shortField);
  });

  test('Should return null if value is equal than min size', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(5, min: 5)}),
        null);
  });

  test('Should return null if value is bigger than min size', () {
    expect(
        sut.validate({'any_field': faker.randomGenerator.string(10, min: 6)}),
        null);
  });
}
