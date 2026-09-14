import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ec_release_controller.g.dart';

@Riverpod(keepAlive: true)
class EcReleaseController extends _$EcReleaseController {
  @override
  Future<DateTime> build() async {
    final ecParams = await ref.watch(
      activeEcParamsStateControllerProvider.future,
    );
    if (ecParams == null) {
      throw Exception('No active EC parameters found.');
    }
    try {
      return await ref
          .watch(ecReleaseRepositoryProvider)
          .getReleasedAtUtc(ecParams);
    } catch (e) {
      throw Exception(
        'Não foi possível carregar a data da versão do sistema. Entre em contato com o suporte técnico e solicite a atualização da API'
            .hardcoded,
      );
    }
  }
}
