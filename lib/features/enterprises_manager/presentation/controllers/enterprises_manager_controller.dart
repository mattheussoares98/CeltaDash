import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/features/enterprises_manager/domain/domain.dart';
import 'package:celta_dash/features/enterprises_manager/presentation/models/models.dart';
import 'package:celta_dash/features/enterprises_manager/providers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'enterprises_manager_controller.g.dart';

@riverpod
class EnterprisesManagerController extends _$EnterprisesManagerController {
  @override
  Future<EnterprisesManagerState> build() => _loadState();

  Future<bool> addEnterprise(AddEnterpriseParams params) async {
    return _mutate(() async {
      final repository = ref.read(enterprisesManagerRepositoryProvider);
      final addedEnterprise = await repository.addEnterprise(params);
      final selectedEnterprise = await repository.loadSelectedEnterprise();
      if (selectedEnterprise == addedEnterprise) {
        await _activate(addedEnterprise);
      }
    });
  }

  Future<bool> selectEnterprise(FirebaseEnterpriseEntity enterprise) async {
    if (state.value?.isSelected(enterprise) == true) return true;

    return _mutate(() => _activate(enterprise));
  }

  Future<bool> removeEnterprise(FirebaseEnterpriseEntity enterprise) async {
    return _mutate(() async {
      await ref
          .read(enterprisesManagerRepositoryProvider)
          .removeEnterprise(enterprise);
    });
  }

  Future<bool> _mutate(Future<void> Function() action) async {
    final currentState = state.value;
    if (currentState == null || currentState.isProcessing) return false;

    state = AsyncValue.data(
      currentState.copyWith(isProcessing: true, clearActionError: true),
    );
    try {
      await action();
      state = AsyncValue.data(await _loadState());
      return true;
    } catch (error) {
      state = AsyncValue.data(
        currentState.copyWith(actionError: error, isProcessing: false),
      );
      return false;
    }
  }

  Future<EnterprisesManagerState> _loadState() async {
    final repository = ref.read(enterprisesManagerRepositoryProvider);
    final enterprises = await repository.loadEnterprises();
    final selectedEnterprise = await repository.loadSelectedEnterprise();
    final state = EnterprisesManagerState(
      enterprises: enterprises,
      selectedEnterpriseId: selectedEnterprise?.firebaseId,
      selectedEnterpriseName: selectedEnterprise?.enterpriseName,
    );
    final orderedEnterprises = [...enterprises]
      ..sort((first, second) {
        final firstIsSelected = state.isSelected(first);
        final secondIsSelected = state.isSelected(second);
        if (firstIsSelected != secondIsSelected) {
          return firstIsSelected ? -1 : 1;
        }
        return (first.enterpriseName ?? '').toLowerCase().compareTo(
          (second.enterpriseName ?? '').toLowerCase(),
        );
      });
    return EnterprisesManagerState(
      enterprises: orderedEnterprises,
      selectedEnterpriseId: state.selectedEnterpriseId,
      selectedEnterpriseName: state.selectedEnterpriseName,
    );
  }

  Future<void> _activate(FirebaseEnterpriseEntity enterprise) async {
    final params = EcParams.fromFirebaseEnterprise(enterprise);
    if (params == null) {
      throw AppException(
        'Os dados de acesso da empresa estão incompletos'.hardcoded,
      );
    }
    await ref
        .read(activeEcParamsStateControllerProvider.notifier)
        .updateParams(params: params, enterprise: enterprise);
  }
}
