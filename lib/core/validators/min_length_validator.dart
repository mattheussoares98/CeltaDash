import 'package:celta_dash/core/validators/validators.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';

class MinLengthValidator implements StringValidator {
  final int minLength;

  MinLengthValidator(this.minLength);

  @override
  String get errorMessage =>
      'Precisa ter pelo menos $minLength caracteres'.hardcoded;

  @override
  bool isValid(String? value) {
    return value != null && value.length >= minLength;
  }
}
