import 'package:celta_dash/core/validators/validators.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';

class IpValidator implements StringValidator {
  String? _errorMessage;

  @override
  String get errorMessage =>
      _errorMessage ?? 'Formato de IP inválido'.hardcoded;

  @override
  bool isValid(String? value) {
    if (value == null || value.trim().isEmpty) {
      _errorMessage = 'Formato de IP inválido'.hardcoded;
      return false;
    }

    // This RegExp validates an IPv4 address, checking that each of
    // the four octets is a number between 0 and 255.
    final ipRegex = RegExp(
      r'^(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.'
      r'(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.'
      r'(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.'
      r'(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$',
    );

    if (ipRegex.hasMatch(value.trim())) {
      _errorMessage = null;
      return true;
    } else {
      _errorMessage = 'Formato de IP inválido'.hardcoded;
      return false;
    }
  }
}
