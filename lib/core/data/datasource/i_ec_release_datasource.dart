import 'package:celta_dash/core/domain/domain.dart';

abstract class IEcReleaseDatasource {
  Future<String> getReleasedAtUtc(EcParams params);
}
