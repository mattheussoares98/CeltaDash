import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class UrlFieldValidation implements FieldValidation {
  @override
  ValidationError? validate(String? value) {
    final uri = Uri.tryParse(value ?? '');

    bool isValid = uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;

    return isValid ? null : ValidationError.invalidUrl;
  }
}
