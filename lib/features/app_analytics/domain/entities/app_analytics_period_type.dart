// lib/features/app_analytics/domain/entities/app_analytics_period_type.dart
enum AppAnalyticsPeriodType {
  hourly('Hora'),
  daily('Diário'),
  weekly('Semanal'),
  monthly('Mensal'),
  personalized('Personalizado'),
  yearly('Anual');

  final String label;
  const AppAnalyticsPeriodType(this.label);
}
