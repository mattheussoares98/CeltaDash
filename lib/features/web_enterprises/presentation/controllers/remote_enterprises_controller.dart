import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/features/web_enterprises/providers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_enterprises_controller.g.dart';

@riverpod
class RemoteEnterprisesController extends _$RemoteEnterprisesController {
  @override
  Future<List<FirebaseEnterpriseEntity>> build() {
    ref.cache();
    return ref.read(webEnterprisesRepositoryProvider).getEnterprises();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      ref.read(webEnterprisesRepositoryProvider).getEnterprises,
    );
  }

  Future<void> updateEnterprise(FirebaseEnterpriseEntity enterprise) async {
    await ref
        .read(webEnterprisesRepositoryProvider)
        .updateEnterprise(enterprise);

    final enterprises = state.value;
    if (enterprises == null) return;
    final index = enterprises.indexWhere(
      (item) => item.firebaseId == enterprise.firebaseId,
    );
    if (index == -1) return;

    final updatedEnterprises = [...enterprises];
    updatedEnterprises[index] = enterprise;
    state = AsyncData(updatedEnterprises);
  }
}
