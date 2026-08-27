// lib/features/group_summary/presentation/models/group_summary_period.dart
import 'package:celta_dash/core/domain/helpers/helpers.dart';

enum GroupSummaryPeriod {
  daily('Dia'),
  monthly('Mês');

  final String label;
  const GroupSummaryPeriod(this.label);

  PeriodGroupingType get periodGroupingType => switch (this) {
    GroupSummaryPeriod.daily => PeriodGroupingType.day,
    GroupSummaryPeriod.monthly => PeriodGroupingType.month,
  };
}
