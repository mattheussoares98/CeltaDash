import '../../presentation/protocols/protocols.dart';

abstract class FieldValidation {
  ValidationError? validate(String? input);
}
