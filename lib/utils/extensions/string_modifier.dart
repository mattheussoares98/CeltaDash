import 'package:intl/intl.dart';

extension StringModifier on String {
  String toBrazilianNumber([
    int decimalHouses = 2,
    bool showDecimalUntilLastNumber = false,
  ]) {
    // Example input: "0,395" with decimalHouses = 2
    // cleanString = "0.395"
    final cleanString = replaceAll(',', '.');
    final value = double.tryParse(cleanString);
    if (value == null) {
      return this;
    }

    // mod = 100.0 (multiplier for 2 decimal places)
    double mod = 1.0;
    for (int i = 0; i < decimalHouses; i++) {
      mod *= 10;
    }

    // sign = 1 (positive number)
    final sign = value.isNegative ? -1 : 1;
    // value.abs() * mod = 39.5
    // 39.5 - 0.5 = 39.0
    // ceil(39.0) = 39
    // 39 / 100 * 1 = 0.39
    final roundedValue = ((value.abs() * mod) - 0.5).ceil() / mod * sign;
    // formatted = "0.39"
    String formatted = roundedValue.toStringAsFixed(decimalHouses);

    if (showDecimalUntilLastNumber && formatted.contains('.')) {
      formatted = formatted
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }

    // parts = ["0", "39"]
    final parts = formatted.split('.');
    // Formats integer part with thousands separators (e.g., "1234" -> "1.234")
    parts[0] = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    // Returns "0,39"
    return parts.join(',');
  }

  String addBrazilianCoin() {
    return "R\$ $this";
  }

  String removeWhiteSpaces() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  double? toDouble() {
    String string = replaceAll(RegExp(r','), '.');
    final quantidadeDePontos = '.'.allMatches(string).length;

    quantidadeDePontos.toString();
    if (quantidadeDePontos > 1) {
      for (var x = 1; x < quantidadeDePontos; x++) {
        if (x < quantidadeDePontos) {
          string = string.replaceFirst(RegExp(r'\.'), '');
        }
      }
    }

    return double.tryParse(string);
  }

  int? toInt([bool removePoints = false]) {
    if (removePoints) {
      return int.tryParse(
        replaceAll(RegExp(r','), '').replaceAll(RegExp(r'\.'), ''),
      );
    } else {
      return int.tryParse(this);
    }
  }

  String formatBreakLines() {
    return replaceAll(
      r'\r\n',
      '\n',
    ).replaceAll(r'\n', '\n').replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  }

  String? formattedPacking() {
    final firstDigitMatch = RegExp(r'\d').firstMatch(this);

    if (firstDigitMatch == null) {
      return this;
    }

    final index = firstDigitMatch.start;
    final textPart = this.substring(0, index);
    var numberPart = this.substring(index);

    if (numberPart.contains('.')) {
      while (numberPart.endsWith('0')) {
        numberPart = numberPart.substring(0, numberPart.length - 1);
      }

      if (numberPart.endsWith('.')) {
        numberPart = numberPart.substring(0, numberPart.length - 1);
      }
    }

    return '$textPart$numberPart'.replaceAll(RegExp(r'\.'), ',');
  }

  String removeAccents() {
    const withDiacritics =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const withoutDiacritics =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    String str = this;
    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }

    // After replacing known characters, we also remove any
    // remaining non-ASCII characters that the printer can't handle.
    str = str.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

    return str;
  }

  DateTime? toDateTime({bool includeTime = false}) {
    try {
      final List<String> sections = includeTime ? split(' ') : [this];
      final List<String> dateParts = sections[0].split('/');

      if (dateParts.length == 3) {
        String isoString = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';

        if (includeTime && sections.length > 1) {
          isoString += ' ${sections[1]}';
        }

        return DateTime.parse(isoString);
      } else if (dateParts.length == 2) {
        final formats = [DateFormat('MM/yyyy'), DateFormat('MM/yy')];

        for (final format in formats) {
          try {
            return format.parseStrict(sections[0]);
          } catch (_) {
            continue;
          }
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  String toMaskedCnpjCpf() {
    // Strip non-digits to handle both formatted and raw values
    final digits = replaceAll(RegExp(r'\D'), '');

    if (digits.length == 11) {
      // CPF Standard Mask: 123.***.***-00
      final first = digits.substring(0, 3);
      final last = digits.substring(9);
      return '$first.***.***-$last';
    } else if (digits.length == 14) {
      // CNPJ Standard Mask: 12.***.***/****-99
      final first = digits.substring(0, 2);
      final last = digits.substring(12);
      return '$first.***.***/****-$last';
    } else {
      return this;
    }
  }
}
