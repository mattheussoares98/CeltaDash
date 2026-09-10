import 'dart:async';

import 'package:celta_dash/core/domain/domain.dart';
import 'package:celta_dash/core/presentation/presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MutableActiveEcParams extends ActiveEcParamsStateController {
  MutableActiveEcParams(this.initialValue);

  final EcParams? initialValue;

  @override
  FutureOr<EcParams?> build() => initialValue;

  void setValue(EcParams? value) {
    state = AsyncValue.data(value);
  }
}
