import 'dart:async';

import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/providers.dart';

export 'fake_daily_comparison_controller.dart';

class FakeActiveEcParams extends ActiveEcParamsStateController {
  final EcParams? initialParams;
  FakeActiveEcParams([this.initialParams]);

  @override
  FutureOr<EcParams?> build() => initialParams;
}
