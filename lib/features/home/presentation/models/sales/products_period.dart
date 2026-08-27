// lib/features/home/presentation/models/products_period.dart
import 'package:celta_dash/core/domain/helpers/helpers.dart';

enum ProductsPeriod {
  daily('Dia'),
  monthly('Mês');

  final String label;
  const ProductsPeriod(this.label);

  PeriodGroupingType get periodGroupingType => switch (this) {
    ProductsPeriod.daily => PeriodGroupingType.day,
    ProductsPeriod.monthly => PeriodGroupingType.month,
  };
}
