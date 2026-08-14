// lib/features/sale_statistics/presentation/controllers/sale_statistics_controller.dart
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/domain/helpers/helpers.dart';
import 'package:celta_dash/features/sale_statistics/domain/entities/entities.dart';
import 'package:celta_dash/features/sale_statistics/providers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sale_statistics_controller.g.dart';

@riverpod
class SaleStatisticsController extends _$SaleStatisticsController {
  GetSaleStatisticsParams? _lastLoadedParams;
  GetSaleStatisticsParams? get lastLoadedParams => _lastLoadedParams;

  @override
  AsyncValue<List<SaleStatisticsEntity>> build(
    CategoryGroupingType groupingType,
  ) {
    ref.cache(60);
    ref.watch(activeEcParamsStateControllerProvider);
    return const AsyncValue.data([]);
  }

  Future<void> loadStatistics({
    required GetSaleStatisticsParams params,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _lastLoadedParams == params && state.hasValue) {
      return;
    }

    final ecParams = await ref.read(
      activeEcParamsStateControllerProvider.future,
    );

    if (ecParams == null) {
      state = AsyncValue.error(
        Exception('Active enterprise credentials (EcParams) not found.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(saleStatisticsRepositoryProvider);
      final results = await repository.getSaleStatistics(
        params: params,
        ecParams: ecParams,
      );
      _lastLoadedParams = params;
      return results;
    });
  }
}
