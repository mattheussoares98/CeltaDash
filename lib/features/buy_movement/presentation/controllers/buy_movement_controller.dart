import 'dart:async';

import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_dash/features/buy_movement/presentation/models/models.dart';
import 'package:celta_dash/features/buy_movement/providers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'buy_movement_controller.g.dart';

@riverpod
class BuyMovementController extends _$BuyMovementController {
  SearchBuyMovementDataParamsEntity? _lastLoadedParams;

  @override
  FutureOr<BuyMovementDataResponseEntity> build(
    BuyMovementQuerySlot querySlot,
  ) {
    _lastLoadedParams = null;
    ref.cache();
    ref.invalidatePeriodically();
    ref.watch(activeEcParamsStateControllerProvider);
    return const BuyMovementDataResponseEntity();
  }

  Future<AsyncValue<BuyMovementDataResponseEntity>> loadData({
    required SearchBuyMovementDataParamsEntity params,
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

    state = const AsyncLoading<BuyMovementDataResponseEntity>();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(buyMovementRepositoryProvider);
      final response = await repository.getData(
        params: params,
        ecParams: ecParams,
      );

      _lastLoadedParams = params;
      return response;
    });

    return state;
  }
}
