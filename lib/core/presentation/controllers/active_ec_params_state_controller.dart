import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_ec_params_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ActiveEcParamsStateController extends _$ActiveEcParamsStateController {
  @override
  FutureOr<EcParams?> build() async {
    final storage = ref.read(appStorageProvider);
    final savedEnterprise = await storage.get(DatabaseKeys.enterprise.name);
    if (savedEnterprise != null && savedEnterprise != '') {
      final enterpriseEntity = FirebaseEnterpriseModel.fromJson(
        savedEnterprise,
      ).toEntity();
      return EcParams.fromFirebaseEnterprise(enterpriseEntity);
    }
    return null;
  }

  Future<void> updateParams({
    required EcParams params,
    FirebaseEnterpriseEntity? enterprise,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final storage = ref.read(appStorageProvider);
      if (enterprise != null) {
        await storage.put(
          DatabaseKeys.enterprise.name,
          FirebaseEnterpriseModel.fromEntity(enterprise).toJson(),
        );
      }
      return params;
    });
  }

  Future<void> clear() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final storage = ref.read(appStorageProvider);
      await storage.delete(DatabaseKeys.enterprise.name);
      return null;
    });
  }
}
