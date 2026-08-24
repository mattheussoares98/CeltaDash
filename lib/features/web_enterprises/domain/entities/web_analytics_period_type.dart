enum WebAnalyticsPeriodType {
  hourly('Hora'),
  daily('Diário'),
  weekly('Semanal'),
  monthly('Mensal'),
  personalized('Personalizado'),
  yearly('Anual');

  final String label;
  const WebAnalyticsPeriodType(this.label);
}
