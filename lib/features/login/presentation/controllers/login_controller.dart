// lib/features/login/presentation/controllers/login_controller.dart
import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/login/domain/entities/entities.dart';
import 'package:celta_dash/features/login/providers.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  AsyncValue<void> build() {
    ref.cache();
    return const AsyncValue.data(null);
  }

  Future<bool> login({
    required String enterpriseName,
    required String user,
    required String password,
  }) async {
    bool succeeds = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loginRepositoryProvider);
      final newEnterprise = await repository.login(
        LoginParams(
          enterpriseName: enterpriseName,
          user: user,
          password: password,
        ),
      );

      final storage = ref.read(appStorageProvider);

      // 1. Save as selected enterprise
      await storage.put(
        DatabaseKeys.enterprise.name,
        FirebaseEnterpriseModel.fromEntity(newEnterprise).toJson(),
      );

      // 2. Add to allEnterprises in storage if not present
      final localAllEnterprises = await storage.get(
        DatabaseKeys.allEnterprises.name,
      );
      List<dynamic> allEnterprisesList = [];
      if (localAllEnterprises is List) {
        allEnterprisesList = List.from(localAllEnterprises);
      }

      final cleanEnterpriseName = enterpriseName
          .trim()
          .toLowerCase()
          .removeWhiteSpaces();
      final alreadyExists = allEnterprisesList.any((e) {
        final name = (e as Map)['enterpriseName']
            ?.toString()
            .toLowerCase()
            .removeWhiteSpaces();
        return name == cleanEnterpriseName;
      });

      if (!alreadyExists) {
        allEnterprisesList.add(
          FirebaseEnterpriseModel.fromEntity(newEnterprise).toJson(),
        );
        await storage.put(DatabaseKeys.allEnterprises.name, allEnterprisesList);
      }

      // 3. Update ActiveEcParamsStateController
      final ecParams = EcParams.fromFirebaseEnterprise(newEnterprise);
      if (ecParams != null) {
        await ref
            .read(activeEcParamsStateControllerProvider.notifier)
            .updateParams(params: ecParams, enterprise: newEnterprise);
      }
      succeeds = true;
    });
    return succeeds;
  }
}
