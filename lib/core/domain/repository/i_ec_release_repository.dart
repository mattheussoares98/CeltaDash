import 'package:celta_dash/core/domain/domain.dart';

abstract class IEcReleaseRepository {
  Future<DateTime> getReleasedAtUtc(EcParams params);
}
