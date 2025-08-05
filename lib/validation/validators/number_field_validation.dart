import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

import 'package:equatable/equatable.dart';

class NumberFieldValidation extends Equatable implements FieldValidation {
  final bool onlyInt;
  const NumberFieldValidation({required this.onlyInt});

  @override
  List get props => [onlyInt];

  @override
  ValidationError? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (onlyInt && int.tryParse(value) == null) {
      return ValidationError.invalidNumber;
    } else if (!onlyInt && double.tryParse(value) == null) {
      return ValidationError.invalidNumber;
    } else {
      return null;
    }
  }
}
