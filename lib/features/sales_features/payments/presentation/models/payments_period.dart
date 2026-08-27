import 'package:celta_dash/core/domain/helpers/helpers.dart';

enum PaymentsPeriod {
  daily('Dia'),
  monthly('Mês');

  final String label;
  const PaymentsPeriod(this.label);

  PeriodGroupingType get periodGroupingType => switch (this) {
    PaymentsPeriod.daily => PeriodGroupingType.day,
    PaymentsPeriod.monthly => PeriodGroupingType.month,
  };
}
