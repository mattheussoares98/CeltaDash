import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/presentation/models/models.dart';
import 'package:celta_dash/features/home/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {
  int _requestVersion = 0;

  @override
  Future<HomeState> build() async {
    final repository = ref.watch(homeRepositoryProvider);
    final appMode = await repository.loadAppMode();
    final initialState = HomeState.initial(appMode: appMode);
    final ecParams = await ref.watch(
      activeEcParamsStateControllerProvider.future,
    );
    if (ecParams == null) return initialState;

    return _loadEnterprises(
      repository: repository,
      ecParams: ecParams,
      previousState: initialState,
    );
  }

  void selectDate(DateTime date) {
    final current = state.value;
    if (current == null || current.selectedDate == date) return;
    state = AsyncValue.data(current.copyWith(selectedDate: date));
  }

  void selectEnterprise(int enterpriseId) {
    final current = state.value;
    if (current == null || current.selectedEnterpriseId == enterpriseId) return;

    final enterprise = current.enterprises
        .where((item) => item.id == enterpriseId)
        .firstOrNull;
    if (enterprise == null || !enterprise.enabled) {
      state = AsyncValue.data(
        current.copyWith(selectionError: 'This enterprise is disabled.'),
      );
      return;
    }

    state = AsyncValue.data(
      current.copyWith(
        selectedEnterpriseId: enterpriseId,
        clearSelectionError: true,
      ),
    );
  }

  void clearSelectionError() {
    final current = state.value;
    if (current == null || current.selectionError == null) return;
    state = AsyncValue.data(current.copyWith(clearSelectionError: true));
  }

  Future<void> toggleAppMode() async {
    final current = state.value;
    if (current == null) return;
    final newMode = current.appMode == AppMode.sales
        ? AppMode.financialTitles
        : AppMode.sales;

    await ref.read(homeRepositoryProvider).saveAppMode(newMode);
    if (state.value case final latest?) {
      state = AsyncValue.data(latest.copyWith(appMode: newMode));
    }
  }

  Future<void> logout() async {
    await ref.read(homeRepositoryProvider).logout();
    ref.invalidate(activeEcParamsStateControllerProvider);
    ref.invalidateSelf();
  }

  Future<void> refreshEnterprises() async {
    final current = state.value;
    if (current == null) return;
    final requestVersion = ++_requestVersion;
    state = AsyncValue.data(current.copyWith(isRefreshing: true));

    try {
      final ecParams = await ref.read(
        activeEcParamsStateControllerProvider.future,
      );
      if (ecParams == null || requestVersion != _requestVersion) return;
      final repository = ref.read(homeRepositoryProvider);
      final refreshed = await _loadEnterprises(
        repository: repository,
        ecParams: ecParams,
        previousState: current,
      );
      if (requestVersion == _requestVersion) {
        state = AsyncValue.data(refreshed);
      }
    } catch (error, stackTrace) {
      if (requestVersion == _requestVersion) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<HomeState> _loadEnterprises({
    required IHomeRepository repository,
    required EcParams ecParams,
    required HomeState previousState,
  }) async {
    final activeEnterprise = await repository.loadActiveEnterprise();
    final enterprises = await repository.getEnterprises(ecParams);
    final enabledById = {
      for (final enterprise
          in activeEnterprise?.firebaseSubEnterprises ?? const [])
        if (enterprise.id != null) enterprise.id: enterprise.enabled == true,
    };
    final reconciled = enterprises
        .map(
          (enterprise) =>
              enterprise.copyWith(enabled: enabledById[enterprise.id] ?? false),
        )
        .toList(growable: false);
    final selectedId =
        reconciled.any(
          (enterprise) => enterprise.id == previousState.selectedEnterpriseId,
        )
        ? previousState.selectedEnterpriseId
        : reconciled.firstOrNull?.id;

    return previousState.copyWith(
      enterprises: reconciled,
      selectedEnterpriseId: selectedId,
      clearSelectedEnterpriseId: selectedId == null,
      isRefreshing: false,
      clearSelectionError: true,
    );
  }
}
