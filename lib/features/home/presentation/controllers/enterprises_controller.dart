import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/home/domain/domain.dart';
import 'package:celta_dash/features/home/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'enterprises_controller.g.dart';

@Riverpod(keepAlive: true)
class EnterprisesController extends _$EnterprisesController {
  @override
  Future<List<HomeEnterpriseEntity>> build() async {
    final ecParams = await ref.watch(
      activeEcParamsStateControllerProvider.future,
    );
    if (ecParams == null) return const [];

    final repository = ref.watch(homeRepositoryProvider);
    final activeEnterprise = await repository.loadActiveEnterprise();
    final enterprises = await repository.getEnterprises(ecParams);
    final enabledById = {
      for (final enterprise
          in activeEnterprise?.firebaseSubEnterprises ??
              const <FirebaseSubEnterpriseEntity>[])
        if (enterprise.id != null) enterprise.id: enterprise.enabled == true,
    };

    return enterprises
        .map(
          (enterprise) =>
              enterprise.copyWith(enabled: enabledById[enterprise.id] ?? false),
        )
        .toList(growable: false);
  }
}
