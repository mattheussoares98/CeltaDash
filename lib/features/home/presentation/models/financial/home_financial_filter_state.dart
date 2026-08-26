import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class HomeFinancialFilterState extends Equatable {
  const HomeFinancialFilterState({
    this.periodType = FinancialTitlePeriodType.expiration,
    this.situations = const {...FinancialTitleSituation.values},
  });

  final FinancialTitlePeriodType periodType;
  final Set<FinancialTitleSituation> situations;

  HomeFinancialFilterState copyWith({
    FinancialTitlePeriodType? periodType,
    Set<FinancialTitleSituation>? situations,
  }) {
    return HomeFinancialFilterState(
      periodType: periodType ?? this.periodType,
      situations: situations ?? this.situations,
    );
  }

  @override
  List<Object> get props => [periodType, situations];
}
