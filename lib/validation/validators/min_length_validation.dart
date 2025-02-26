import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

import 'package:equatable/equatable.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  final int size;

  @override
  List get props => [field, size];

  const MinLengthValidation({required this.field, required this.size});

  @override
  ValidationError? validate(Map input) {
    if (input[field] == null) {
      return ValidationError.shortField;
    } else if (input[field].length < size) {
      return ValidationError.shortField;
    } else if (input[field] == null) {
      return ValidationError.invalidField;
    } else {
      return null;
    }
  }
}
