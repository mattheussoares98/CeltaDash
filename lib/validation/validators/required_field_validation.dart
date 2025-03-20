import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation {
  const RequiredFieldValidation();

  @override
  ValidationError? validate(String? value) =>
      value?.isNotEmpty == true ? null : ValidationError.requiredField;
}
