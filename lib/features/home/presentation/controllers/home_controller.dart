import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/home.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {
  @override
  Future<HomeState> build() async {
    ref.watch(activeEcParamsStateControllerProvider);
    final previousState = state.value;
    final repository = ref.watch(homeRepositoryProvider);
    final appMode = previousState?.appMode ?? await repository.loadAppMode();
    final homeState = previousState ?? HomeState.initial(appMode: appMode);
    final enterprises = await ref.watch(enterprisesControllerProvider.future);
    final selectedEnterpriseId = _resolveSelectedEnterpriseId(
      enterprises: enterprises,
      currentId: homeState.selectedEnterpriseId,
    );

    if (selectedEnterpriseId != null) {
      _setCrashlyticsEnterpriseKeys(selectedEnterpriseId, enterprises);
    }

    return homeState.copyWith(
      selectedEnterpriseId: selectedEnterpriseId,
      clearSelectedEnterpriseId: selectedEnterpriseId == null,
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

    final enterprises = ref.read(enterprisesControllerProvider).value;
    final enterprise = enterprises
        ?.where((item) => item.id == enterpriseId)
        .firstOrNull;
    if (enterprise == null || !enterprise.enabled) return;

    _setCrashlyticsEnterpriseKeys(enterpriseId, enterprises);

    state = AsyncValue.data(
      current.copyWith(selectedEnterpriseId: enterpriseId),
    );
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
    ref.invalidate(enterprisesControllerProvider);
    ref.invalidateSelf();
  }

  int? _resolveSelectedEnterpriseId({
    required List<HomeEnterpriseEntity> enterprises,
    required int? currentId,
  }) {
    for (final enterprise in enterprises) {
      if (enterprise.id == currentId && enterprise.enabled) return currentId;
    }
    for (final enterprise in enterprises) {
      if (enterprise.id != null && enterprise.enabled) return enterprise.id;
    }
    return enterprises.firstOrNull?.id;
  }

  void _setCrashlyticsEnterpriseKeys(
    int enterpriseId,
    List<HomeEnterpriseEntity>? enterprises,
  ) {
    final enterprise = enterprises
        ?.where((e) => e.id == enterpriseId)
        .firstOrNull;
    final enterpriseName = enterprise?.name;

    ref.read(crashlyticsServiceProvider).setCustomKeys([
      CrashlyticsCustomKeyEntity(
        key: 'selected_enterprise_id',
        value: enterpriseId,
      ),
      if (enterpriseName != null && enterpriseName.isNotEmpty)
        CrashlyticsCustomKeyEntity(
          key: 'selected_enterprise_name',
          value: enterpriseName,
        ),
    ]);
  }
}
