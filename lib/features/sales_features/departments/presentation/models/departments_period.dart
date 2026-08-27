// lib/features/departments/presentation/models/departments_period.dart
import 'package:celta_dash/core/domain/helpers/helpers.dart';

enum DepartmentsPeriod {
  daily('Dia'),
  monthly('Mês');

  final String label;
  const DepartmentsPeriod(this.label);

  PeriodGroupingType get periodGroupingType => switch (this) {
    DepartmentsPeriod.daily => PeriodGroupingType.day,
    DepartmentsPeriod.monthly => PeriodGroupingType.month,
  };
}
