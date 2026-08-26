import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_financial_filters_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeFinancialFiltersController extends _$HomeFinancialFiltersController {
  @override
  HomeFinancialFilterState build() => const HomeFinancialFilterState();

  void setPeriodType(FinancialTitlePeriodType periodType) {
    if (state.periodType == periodType) return;
    state = state.copyWith(periodType: periodType);
  }

  void toggleSituation(FinancialTitleSituation situation) {
    final alreadyContains = state.situations.contains(situation);
    if (alreadyContains && state.situations.length == 1) {
      return;
    } else if (alreadyContains) {
      state = state.copyWith(
        situations: Set.unmodifiable({...state.situations}..remove(situation)),
      );
    } else {
      state = state.copyWith(
        situations: Set.unmodifiable({...state.situations}..add(situation)),
      );
    }
  }
}
