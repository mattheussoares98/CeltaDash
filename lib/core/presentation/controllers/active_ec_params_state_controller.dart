// lib/core/presentation/controllers/active_ec_params_controller.dart
import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/data/models/models.dart';
import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/infra/helpers/helpers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_ec_params_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ActiveEcParamsStateController extends _$ActiveEcParamsStateController {
  @override
  FutureOr<EcParams?> build() async {
    final storage = ref.read(localStorageProvider);
    final savedEnterprise = await storage.get(DatabaseKeys.enterprise);
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
    state = AsyncValue.data(params);
    state = await AsyncValue.guard(() async {
      final storage = ref.read(localStorageProvider);
      if (enterprise != null) {
        await storage.put(
          DatabaseKeys.enterprise,
          FirebaseEnterpriseModel.fromEntity(enterprise).toJson(),
        );
      }
      return params;
    });
  }

  Future<void> clear() async {
    state = const AsyncValue.data(null);
    state = await AsyncValue.guard(() async {
      final storage = ref.read(localStorageProvider);
      await storage.delete(DatabaseKeys.enterprise);
      return null;
    });
  }
}
