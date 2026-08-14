import 'package:celta_dash/core/validators/validators.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/validators/validators.dart';

void main() {
  group('FormValidators.compose', () {
    test('Should return null when the list of validators is empty', () {
      final composedValidator = FormValidators.compose([]);
      final result = composedValidator(faker.lorem.word());
      expect(result, isNull);
    });

    test('Should return null when all validators pass', () {
      final composedValidator = FormValidators.compose([
        MockSuccessValidator(),
        MockSuccessValidator(),
      ]);
      final result = composedValidator(faker.lorem.word());
      expect(result, isNull);
    });

    test(
      'Should return the error message of the first validator that fails',
      () {
        final error1 = faker.lorem.sentence();
        final error2 = faker.lorem.sentence();

        final composedValidator = FormValidators.compose([
          MockFailureValidator(error1),
          MockFailureValidator(error2),
        ]);
        final result = composedValidator(faker.lorem.word());

        expect(result, error1);
      },
    );

    test(
      'Should return the error message of the second validator if the first passes',
      () {
        final error2 = faker.lorem.sentence();
        final composedValidator = FormValidators.compose([
          MockSuccessValidator(),
          MockFailureValidator(error2),
        ]);
        final result = composedValidator(faker.lorem.word());
        expect(result, error2);
      },
    );

    test('Should correctly pass the input value to each validator', () {
      final inputValue = faker.internet.email();
      String? receivedValue;

      final captorValidator = MockSuccessValidator();

      bool spiedIsValid(String? value) {
        receivedValue = value;
        return captorValidator.isValid(value);
      }

      final composedValidator = FormValidators.compose([
        _TestValidator(spiedIsValid, ''),
      ]);

      composedValidator(inputValue);
      expect(receivedValue, inputValue);
    });
  });
}

class _TestValidator implements StringValidator {
  final bool Function(String?) _isValidFn;
  @override
  final String errorMessage;
  _TestValidator(this._isValidFn, this.errorMessage);
  @override
  bool isValid(String? value) => _isValidFn(value);
}
