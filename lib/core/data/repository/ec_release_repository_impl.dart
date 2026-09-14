import 'package:celta_dash/core/data/data.dart';
import 'package:celta_dash/core/domain/domain.dart';

class EcReleaseRepositoryImpl implements IEcReleaseRepository {
  const EcReleaseRepositoryImpl(this._datasource);

  final IEcReleaseDatasource _datasource;

  @override
  Future<DateTime> getReleasedAtUtc(EcParams params) async {
    final releasedAtUtc = await _datasource.getReleasedAtUtc(params);
    return DateTime.parse(releasedAtUtc).toUtc();
  }
}
