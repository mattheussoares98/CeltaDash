import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

import 'package:equatable/equatable.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final int size;
  const MinLengthValidation({required this.size});

  @override
  List get props => [size];

  @override
  ValidationError? validate(String? value) {
    if (value == null) {
      return ValidationError.requiredField;
    } else if (value.length < size) {
      return ValidationError.shortField;
    } else {
      return null;
    }
  }
}
