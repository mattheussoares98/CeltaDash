import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class EmailFieldValidation implements FieldValidation {
  const EmailFieldValidation();

  @override
  ValidationError? validate(String? value) =>
      RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          ).hasMatch(value ?? '')
          ? null
          : ValidationError.invalidEmail;
}
