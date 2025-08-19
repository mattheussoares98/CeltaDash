import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BrazilianRealInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is empty, return it as is.
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // 1. Clean the input to only contain digits.
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // 2. Parse the digits into a number.
    final number = double.parse(digitsOnly);

    // 3. Format the number into the Brazilian Real format (without the R$ symbol).
    // The '/ 100' is used to treat the input as cents. For example, '123' becomes '1,23'.
    final formatter =
        NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
    final newString = formatter.format(number / 100);

    // 4. Return the new TextEditingValue with the formatted text and corrected cursor position.
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
