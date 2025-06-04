import 'package:celta_dash/presentation/protocols/protocols.dart';
import 'package:celta_dash/validation/protocols/protocols.dart';

import 'package:mocktail/mocktail.dart';

class FieldValidationSpy extends Mock implements FieldValidation {
  FieldValidationSpy() {
    this.mockValidation();
  }

  When _mockValidationCall() => when(() => this.validate(any()));
  void mockValidation() => this._mockValidationCall().thenReturn(null);
  void mockValidationError(ValidationError error) =>
      this._mockValidationCall().thenReturn(error);
}
