import 'package:celta_dash/core/validators/validators.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';

class NonEmptyValidator implements StringValidator {
  @override
  String get errorMessage => 'Campo obrigatório'.hardcoded;

  @override
  bool isValid(String? value) {
    return value?.isNotEmpty ?? false;
  }
}
