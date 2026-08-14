import 'package:celta_dash/core/validators/string_validator.dart';

class MockFailureValidator implements StringValidator {
  final String message;
  MockFailureValidator(this.message);

  @override
  String get errorMessage => message;

  @override
  bool isValid(String? value) => false;
}
