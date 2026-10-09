// lib/features/financial_titles/presentation/controllers/financial_titles_controller.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/financial_titles/domain/entities/entities.dart';
import 'package:celta_dash/features/financial_titles/providers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'financial_titles_controller.g.dart';

@riverpod
class FinancialTitlesController extends _$FinancialTitlesController {
  SearchFinancialTitleDataParams? _lastLoadedParams;
  SearchFinancialTitleDataParams? get lastLoadedParams => _lastLoadedParams;

  @override
  AsyncValue<FinancialTitleDataResponseEntity> build({
    FinancialTitlePeriodGrouping? periodGrouping,
    FinancialTitlePeriodType periodType = FinancialTitlePeriodType.expiration,
  }) {
    ref.cache();
    ref.invalidatePeriodically();
    ref.watch(activeEcParamsStateControllerProvider);
    _lastLoadedParams = null;
    return const AsyncValue.data(FinancialTitleDataResponseEntity());
  }

  Future<AsyncValue<FinancialTitleDataResponseEntity>> loadData({
    required SearchFinancialTitleDataParams params,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _lastLoadedParams == params && state.hasValue) {
      return state;
    }

    final ecParams = await ref.read(
      activeEcParamsStateControllerProvider.future,
    );

    if (ecParams == null) {
      state = AsyncValue.error(
        Exception('Credenciais da empresa ativa não encontradas'.hardcoded),
        StackTrace.current,
      );
      return state;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(financialTitlesRepositoryProvider);
      final results = await repository.getData(
        params: params,
        ecParams: ecParams,
      );
      _lastLoadedParams = params;
      return results;
    });
    return state;
  }
}
