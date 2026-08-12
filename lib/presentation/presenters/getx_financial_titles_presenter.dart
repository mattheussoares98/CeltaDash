import 'dart:async';

import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxFinancialTitlesPresenter extends GetxController
    with ErrorHandling
    implements FinancialTitlesPresenter {
  final LoadFinancialTitleData loadFinancialTitleData;
  final Duration cacheDuration;

  final _states = <FinancialTitleRequestKey, Rx<FinancialTitleState>>{};
  final _expirationTimers = <FinancialTitleRequestKey, Timer>{};
  final _requestVersions = <FinancialTitleRequestKey, int>{};

  GetxFinancialTitlesPresenter({
    required this.loadFinancialTitleData,
    this.cacheDuration = const Duration(minutes: 5),
  });

  Rx<FinancialTitleState> _stateChannel(FinancialTitleRequestKey key) =>
      _states.putIfAbsent(
        key,
        () => Rx(
          const FinancialTitleState(status: FinancialTitleStatus.initial),
        ),
      );

  @override
  FinancialTitleState stateOf(FinancialTitleRequestKey key) =>
      _stateChannel(key).value;

  @override
  Stream<FinancialTitleState> streamOf(FinancialTitleRequestKey key) =>
      _stateChannel(key).stream;

  @override
  Future<void> load({
    required FinancialTitleRequestKey key,
    required SearchFinancialTitleDataParams params,
    bool forceRefresh = false,
  }) async {
    final channel = _stateChannel(key);
    final currentState = channel.value;

    if (!forceRefresh && currentState.status == FinancialTitleStatus.success) {
      _scheduleExpiration(key, _requestVersions[key]!);
      return;
    }

    if (!forceRefresh && currentState.status == FinancialTitleStatus.loading) {
      return;
    }

    _expirationTimers.remove(key)?.cancel();

    // A newer request for the same key may finish before this one. The version
    // prevents this older response from overwriting the newer cached state.
    final requestVersion = (_requestVersions[key] ?? 0) + 1;
    _requestVersions[key] = requestVersion;

    final previousData = currentState.data;
    final previousLoadedAt = currentState.loadedAt;

    channel.value = FinancialTitleState(
      status: FinancialTitleStatus.loading,
      params: params,
      data: previousData,
      loadedAt: previousLoadedAt,
    );

    try {
      final data = await loadFinancialTitleData.get(params);
      if (_requestVersions[key] != requestVersion) {
        return;
      }

      channel.value = FinancialTitleState(
        status: FinancialTitleStatus.success,
        params: params,
        data: data,
        loadedAt: DateTime.now(),
      );
      _scheduleExpiration(key, requestVersion);
    } catch (error) {
      if (_requestVersions[key] != requestVersion) {
        return;
      }

      channel.value = FinancialTitleState(
        status: FinancialTitleStatus.failure,
        params: params,
        data: previousData,
        error: getUIError(error),
        loadedAt: previousLoadedAt,
      );
      if (previousData != null) {
        _scheduleExpiration(key, requestVersion);
      }
    }
  }

  void _scheduleExpiration(
    FinancialTitleRequestKey key,
    int requestVersion,
  ) {
    _expirationTimers.remove(key)?.cancel();
    if (cacheDuration <= Duration.zero) {
      _expire(key, requestVersion);
      return;
    }

    _expirationTimers[key] = Timer(
      cacheDuration,
      () => _expire(key, requestVersion),
    );
  }

  void _expire(FinancialTitleRequestKey key, int requestVersion) {
    if (_requestVersions[key] != requestVersion) {
      return;
    }

    _expirationTimers.remove(key)?.cancel();
    _requestVersions[key] = requestVersion + 1;
    _stateChannel(key).value = const FinancialTitleState(
      status: FinancialTitleStatus.initial,
    );
  }

  @override
  void clear(FinancialTitleRequestKey key) {
    _expirationTimers.remove(key)?.cancel();
    _requestVersions[key] = (_requestVersions[key] ?? 0) + 1;
    _stateChannel(key).value = const FinancialTitleState(
      status: FinancialTitleStatus.initial,
    );
  }

  @override
  void onClose() {
    for (final timer in _expirationTimers.values) {
      timer.cancel();
    }
    for (final state in _states.values) {
      state.close();
    }
    _expirationTimers.clear();
    _states.clear();
    _requestVersions.clear();
    super.onClose();
  }
}
