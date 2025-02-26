extension StringModifier on String {
  String toBrazilianNumber([int decimalHouses = 2]) {
    double value = double.parse(this);
    String formatted = value.toStringAsFixed(decimalHouses);

    List<String> parts = formatted.split('.');
    parts[0] = parts[0]
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
    return parts.join(',');
  }

  String addBrazilianCoin() {
    return "R\$ $this";
  }

  String removeWhiteSpaces() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  double toDouble() {
    try {
      if (isEmpty) {
        return -1.0;
      }

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

      return double.parse(string);
    } catch (e) {
      return -1.0;
    }
  }

  int toInt([bool removePoints = false]) {
    try {
      if (removePoints) {
        return int.parse(
            replaceAll(RegExp(r','), '').replaceAll(RegExp(r'\.'), ''));
      } else {
        return (double.parse(this)).toInt();
      }
    } catch (e) {
      return -1;
    }
  }

  String removeComplementConfigurations() {
    RegExp optionalRegex = RegExp(r'\(op\|[^|]*\|op\)');
    RegExp obligatoryRegex = RegExp(r'\(ob\|[^|]*\|ob\)');

    return toLowerCase()
        .replaceAll(optionalRegex, '')
        .replaceAll(obligatoryRegex, '')
        .replaceAll(RegExp(r'\(p\)'), '')
        .replaceAll(RegExp(r'\(pp\)'), '')
        .replaceAll(RegExp(r'\(ppp\)'), '')
        .replaceAll(RegExp(r'\(kids\)'), '')
        .replaceAll(RegExp(r'\(novo\)'), '');
  }
}
