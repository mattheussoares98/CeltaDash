enum PeriodType {
  hourly('Hora'),
  daily('Diário'),
  weekly('Semanal'),
  monthly('Mensal'),
  personalized('Personalizado'),
  yearly('Anual');

  final String label;

  const PeriodType(this.label);
}

extension PeriodTypeNameExtension on PeriodType {
  String get descriptionName {
    switch (this) {
      case PeriodType.hourly:
        return 'Hora';
      case PeriodType.daily:
        return 'Dia';
      case PeriodType.weekly:
        return 'Semana';
      case PeriodType.monthly:
        return 'Mês';
      case PeriodType.personalized:
        return 'Personalizado';
      case PeriodType.yearly:
        return 'Ano';
    }
  }
}
