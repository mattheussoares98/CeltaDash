// lib/features/home/presentation/controllers/financial/home_financial_period_type_controller.dart
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_financial_period_type_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeFinancialPeriodTypeController
    extends _$HomeFinancialPeriodTypeController {
  @override
  FinancialTitlePeriodType build() {
    return FinancialTitlePeriodType.emission;
  }

  void setPeriodType(FinancialTitlePeriodType periodType) {
    if (state == periodType) return;
    state = periodType;
  }
}
