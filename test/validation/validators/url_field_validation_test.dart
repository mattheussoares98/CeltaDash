import 'package:celta_plus/presentation/protocols/protocols.dart';
import 'package:celta_plus/validation/validators/validators.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late UrlFieldValidation sut;

  setUp(() {
    sut = UrlFieldValidation();
  });

  test('Should correct error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidUrl);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(""), ValidationError.invalidUrl);
  });

  test('Should return error is a invalid url', () {
    expect(sut.validate(faker.lorem.word()), ValidationError.invalidUrl);
  });
  test('Should return null if is valid url', () {
    expect(sut.validate(faker.internet.httpUrl()), null);
    expect(sut.validate(faker.internet.httpsUrl()), null);
  });
}
