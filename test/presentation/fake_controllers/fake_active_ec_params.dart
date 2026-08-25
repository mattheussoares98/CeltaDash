import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/presentation/presentation.dart';

class FakeActiveEcParams extends ActiveEcParamsStateController {
  FakeActiveEcParams([this.value]);

  final EcParams? value;

  @override
  Future<EcParams?> build() async => value;
}
