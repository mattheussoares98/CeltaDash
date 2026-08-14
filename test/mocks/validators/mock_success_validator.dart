import 'package:celta_dash/core/validators/validators.dart';

class MockSuccessValidator implements StringValidator {
  @override
  String get errorMessage => '';

  @override
  bool isValid(String? value) => true;
}
