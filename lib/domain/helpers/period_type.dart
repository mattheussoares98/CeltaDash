enum PeriodType {
  hourly,
  daily,
  weekly,
  monthly,
  personalized,
  yearly,
}

extension PeriodTypeDescriptionExtension on PeriodType {
  String get description {
    switch (this) {
      case PeriodType.hourly:
        return 'Horário';
      case PeriodType.daily:
        return 'Diário';
      case PeriodType.weekly:
        return 'Semanal';
      case PeriodType.monthly:
        return 'Mensal';
      case PeriodType.personalized:
        return 'Personalizado';
      case PeriodType.yearly:
        return 'Anual';
    }
  }
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
