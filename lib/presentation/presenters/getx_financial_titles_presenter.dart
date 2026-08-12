import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxFinancialTitlesPresenter extends GetxController
    with ErrorHandling
    implements FinancialTitlesPresenter {
  final LoadFinancialTitleData loadFinancialTitleData;

  static const _cacheDuration = Duration(minutes: 5);

  final _states = <FinancialTitleRequestKey, Rx<FinancialTitleState>>{};
  final _requestVersions = <FinancialTitleRequestKey, int>{};

  GetxFinancialTitlesPresenter({
    required this.loadFinancialTitleData,
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

    final isCacheValid = currentState.loadedAt != null &&
        DateTime.now().difference(currentState.loadedAt!) < _cacheDuration;

    if (!forceRefresh &&
        isCacheValid &&
        currentState.status == FinancialTitleStatus.success) {
      return;
    }

    if (!forceRefresh && currentState.status == FinancialTitleStatus.loading) {
      return;
    }

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
    }
  }

  @override
  void release(FinancialTitleRequestKey key) {
    _requestVersions[key] = (_requestVersions[key] ?? 0) + 1;
    _states.remove(key)?.close();
  }

  @override
  void onClose() {
    for (final state in _states.values) {
      state.close();
    }
    _states.clear();
    _requestVersions.clear();
    super.onClose();
  }
}
